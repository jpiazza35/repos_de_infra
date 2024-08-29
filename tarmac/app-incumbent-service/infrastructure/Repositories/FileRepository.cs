using CN.Incumbent.Domain;
using Dapper;
using Microsoft.Extensions.Logging;
using CN.Incumbent.Domain.Models.Dtos;
using CN.Incumbent.Domain.Enum;
using Microsoft.Extensions.Configuration;
using AutoMapper;
using Amazon.Runtime;
using Amazon.S3;
using Amazon.S3.Transfer;
using CN.Incumbent.Models.S3;
using Microsoft.AspNetCore.Http;
using Amazon.S3.Model;
using Amazon;

namespace CN.Incumbent.Infrastructure.Repositories;

public class FileRepository : IFileRepository
{
    private readonly IDBContext _incumbentDBContext;
    private readonly ILogger<FileRepository> _logger;
    private readonly IConfiguration _configuration;
    protected IMapper _mapper;
    private readonly string _bucketName;

    public FileRepository(IDBContext incumbentDBContext, ILogger<FileRepository> logger, IConfiguration configuration, IMapper mapper)
    {
        _incumbentDBContext = incumbentDBContext;
        _logger = logger;
        _configuration = configuration;
        _mapper = mapper;

        _bucketName = _configuration["AwsConfiguration:AWSBucketName"] ?? throw new ArgumentNullException(_configuration["AwsConfiguration:AWSBucketName"]);
    }

    public async Task<FileLogResponseDto> InsertFileLog(SaveFileDto fileLogDetails, string? userObjectId)
    {
        try
        {
            using (var connection = _incumbentDBContext.GetIncumbentConnection())
            {
                connection.Open();
                using (var transaction = connection.BeginTransaction())
                {
                    try
                    {
                        _logger.LogInformation($"\nInserting file record: {fileLogDetails.ClientFileName} \n");

                        var file = fileLogDetails.File ?? throw new ArgumentNullException("File");
                        var fileId = 0;
                        var uploadedUtcDatetime = DateTime.UtcNow;
                        var dateFormat = "yyyyMMddHHmmssfff";
                        var fileStatus = FileStatus.Started;

                        var fileNameWithoutExtension = fileLogDetails.ClientFileName?.Split(".csv");
                        var fileS3Name = $"{fileNameWithoutExtension?.FirstOrDefault()}_{fileLogDetails.ProjectVersion}_{uploadedUtcDatetime.ToString(dateFormat)}.csv";

                        var folderStructure = $"{Constants.S3_FOLDER}/{DateTime.Now.ToString("yyyyMM")}/{fileLogDetails.OrganizationId}/{fileS3Name}";

                        var fileS3Url = $"arn:aws:s3:::{_bucketName}/{folderStructure}";

                        var effectiveDate = fileLogDetails.EffectiveDate;
                        effectiveDate = effectiveDate == DateTime.MinValue || !effectiveDate.HasValue ? DateTime.Now : effectiveDate;

                        var sqlInsert = $@"INSERT INTO file_log(
                                        file_org_key, 
                                        source_data_name, 
                                        data_effective_date, 
                                        uploaded_by, 
                                        uploaded_utc_datetime, 
                                        file_status_key,
                                        client_filename,
                                        file_s3_name,
                                        file_s3_url)
                                VALUES
                                        (@organizationId, 
                                        @sourceDataName, 
                                        @effectiveDate, 
                                        @userObjectId, 
                                        @uploadedUtcDatetime, 
                                        @fileStatus,
                                        @clientFileName,
                                        @fileS3Name,
                                        @fileS3Url)
                                RETURNING file_log_key;";

                        fileId = await connection.ExecuteScalarAsync<int>(sqlInsert,
                        new
                        {
                            fileLogDetails.OrganizationId,
                            fileLogDetails.SourceDataName,
                            fileLogDetails.EffectiveDate,
                            userObjectId,
                            uploadedUtcDatetime,
                            fileStatus,
                            fileLogDetails.ClientFileName,
                            fileS3Name,
                            fileS3Url
                        }, transaction);

                        transaction.Commit();

                        await using MemoryStream memoryStream = new MemoryStream();

                        await file.CopyToAsync(memoryStream);

                        var response = await UploadFileAsync(memoryStream, folderStructure);

                        if (response.Success)
                            await UpdateFileStatusToUploaded(fileId);

                        return new FileLogResponseDto
                        {
                            Success = response.Success,
                            Message = response.Message,
                            FileLogKey = fileId,
                            FileS3Url = fileS3Url,
                            FileS3Name = fileS3Name,
                            BucketName = _bucketName
                        };
                    }
                    catch
                    {
                        transaction.Rollback();
                        throw;
                    }
                }
            }
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    public async Task UpdateFileStatusToUploaded(int fileLogKey)
    {
        try
        {
            _logger.LogInformation($"\nUpdating to uploaded status for file id: {fileLogKey} \n");

            using (var connection = _incumbentDBContext.GetIncumbentConnection())
            {
                var fileStatus = FileStatus.Uploaded;
                var sqlUpdate = $@"UPDATE file_log 
                                   SET file_status_key = @fileStatus 
                                   WHERE file_log_key = @fileLogKey";

                await connection.ExecuteScalarAsync(sqlUpdate,
                    new
                    {
                        fileStatus,
                        fileLogKey
                    });
            }
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    public async Task<IEnumerable<FileLogDto>> GetFileByFilters(int orgId, string sourceData)
    {
        try
        {
            _logger.LogInformation($"\nObtaining files by organization id: {orgId} and source data: {sourceData} \n");

            sourceData = sourceData.ToLower();

            using (var connection = _incumbentDBContext.GetIncumbentConnection())
            {
                var sql = $@"SELECT file_log_key as FileLogKey,
                             file_Org_Key AS FileOrgKey,
                             source_data_name AS SourceDataName,
                             data_effective_date AS DataEffectiveDate,
                             client_filename AS ClientFileName,
                             file_s3_url AS FileS3Url,
                             file_status_key AS FileStatusKey,
                             file_s3_name AS FileS3Name,
                             status_name as FileStatusName

                             FROM file_log 
                             INNER JOIN status_list on status_key = file_status_key
                             WHERE file_org_key = @orgId
                             AND LOWER(source_data_name) = @sourceData
                             ORDER BY data_effective_date DESC";

                var response = await connection.QueryAsync<FileLog>(sql,
                    new
                    {
                        orgId,
                        sourceData
                    });

                return _mapper.Map<IEnumerable<FileLogDto>>(response);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    public async Task<IEnumerable<FileLogDto>> GetFilesByIds(List<int> fileIds)
    {
        try
        {
            _logger.LogInformation($"\nObtaining files for ids: {string.Join(", ", fileIds)} \n");

            using (var connection = _incumbentDBContext.GetIncumbentConnection())
            {
                var files = await connection.QueryAsync<FileLog>($@"SELECT file_log_key AS FileLogKey,
                                                                           file_Org_Key AS FileOrgKey,
                                                                           TRIM(source_data_name) AS SourceDataName,
                                                                           data_effective_date AS DataEffectiveDate,
                                                                           TRIM(client_filename) AS ClientFileName,
                                                                           TRIM(file_s3_url) AS FileS3Url,
                                                                           file_status_key AS FileStatusKey,
                                                                           TRIM(file_s3_name) AS FileS3Name,
                                                                           TRIM(s.status_name) AS FileStatusName
                                                                   FROM file_log
                                                                   INNER JOIN status_list s ON s.status_key = file_status_key
                                                                   WHERE file_log_key = ANY(@fileIds)", new { fileIds });

                return _mapper.Map<IEnumerable<FileLogDto>>(files);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");
            throw;
        }
    }

    public async Task<string> GetFileLinkAsync(int fileKey)
    {
        try
        {
            _logger.LogInformation($"\nObtaining file link by file key: {fileKey}\n");

            var fileName = await GetFileLog(fileKey);

            return await GetFileLinkAsync(fileName);
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    public async Task<string> GetFileLinkAsync(string fileName)
    {
        try
        {
            _logger.LogInformation($"\nObtaining file link by file name: {fileName}\n");

            var startIndex = fileName.IndexOf(Constants.S3_FOLDER);
            if (startIndex != -1)
            {
                fileName = fileName.Substring(startIndex);
            }
            var config = new AmazonS3Config() { RegionEndpoint = RegionEndpoint.USEast1 };

            var request = new GetPreSignedUrlRequest
            {
                BucketName = _bucketName,
                Key = fileName.Trim(),
                Expires = DateTime.UtcNow.AddHours(1)
            };

            using var client = new AmazonS3Client(config);
            string url = client.GetPreSignedURL(request);

            return await Task.FromResult(url);
        }
        catch (AmazonS3Exception s3Ex)
        {
            _logger.LogError($"\nError Amazon S3 {s3Ex.Message}\n");

            throw;
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    public async Task<FileLogResponseDto> UploadMarketPricingSheetPdfFile(byte[] file, MarketPricingSheetPdfDto fileInformation)
    {
        try
        {
            var dateFormat = "yyyyMMddHHmmssfff";
            var fileS3Name = string.Empty;

            if (fileInformation.MarketPricingSheetId != 0)
                fileS3Name = $"mpt_MarketPricingSheet_{fileInformation.OrganizationName}_{fileInformation.ProjectVersionId}_{fileInformation.ReportDate.ToString(dateFormat)}_{fileInformation.MarketPricingSheetId}.pdf";
            else
                fileS3Name = $"mpt_MarketPricingSheet_{fileInformation.OrganizationName}_{fileInformation.ProjectVersionId}_{fileInformation.ReportDate.ToString(dateFormat)}.pdf";

            _logger.LogInformation($"\nInserting pdf record: {fileS3Name} \n");

            var folderStructure = $"{Constants.S3_FOLDER}/{DateTime.Now.ToString("yyyyMM")}/{fileInformation.OrganizationId}/{fileS3Name}";

            var fileS3Url = $"arn:aws:s3:::{_bucketName}/{folderStructure}";

            await using MemoryStream memoryStream = new MemoryStream(file);

            var response = await UploadFileAsync(memoryStream, folderStructure);

            return new FileLogResponseDto
            {
                Success = response.Success,
                Message = response.Message,
                FileS3Url = fileS3Url,
                FileS3Name = fileS3Name,
                BucketName = _bucketName
            };
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    private async Task<S3ResponseDto> UploadFileAsync(MemoryStream memoryStream, string fileS3Name)
    {
        _logger.LogInformation($"\nUploading file in S3 bucket with name: {fileS3Name} \n");

        var response = new S3ResponseDto();
        try
        {
            var s3Obj = new Models.S3.S3Object()
            {
                InputStream = memoryStream,
                Name = fileS3Name
            };

            var config = new AmazonS3Config()
            {
                RegionEndpoint = RegionEndpoint.USEast1
            };

            var uploadRequest = new TransferUtilityUploadRequest()
            {
                InputStream = s3Obj.InputStream,
                Key = s3Obj.Name,
                BucketName = _bucketName,
                CannedACL = S3CannedACL.NoACL
            };

            using var client = new AmazonS3Client(config);

            // initialise the transfer/upload tools
            var transferUtility = new TransferUtility(client);

            await transferUtility.UploadAsync(uploadRequest);

            response.StatusCode = 201;
            response.Message = $"{s3Obj.Name} has been uploaded sucessfully.";
        }
        catch (AmazonS3Exception s3Ex)
        {
            _logger.LogError($"\nError Amazon S3 {s3Ex.Message}\n");

            response.Success = false;
            response.StatusCode = (int)s3Ex.StatusCode;
            response.Message = s3Ex.Message;
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            response.Success = false;
            response.StatusCode = 500;
            response.Message = ex.Message;
        }

        return response;
    }

    private async Task<string> GetFileLog(int fileKey)
    {
        try
        {
            using (var connection = _incumbentDBContext.GetIncumbentConnection())
            {
                var sql = @"SELECT file_s3_url
                            FROM file_log 
                            WHERE file_log_key = @fileKey";

                var fileS3Name = await connection.ExecuteScalarAsync<string>(sql, new { fileKey });

                return fileS3Name;
            }
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }
}
