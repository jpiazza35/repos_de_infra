using AutoMapper;
using Cn.Incumbent;
using CN.Project.Domain.Models.Dto;
using CN.Project.Domain.Models.Dto.MarketPricingSheet;
using Google.Protobuf.WellKnownTypes;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace CN.Project.Infrastructure.Repository;

public class FileRepository : IFileRepository
{
    protected IMapper _mapper;

    private readonly IConfiguration _configuration;
    private readonly ILogger<FileRepository> _logger;
    private readonly Incumbent.IncumbentClient _incumbentClient;

    public FileRepository(IMapper mapper, IConfiguration configuration, ILogger<FileRepository> logger, Incumbent.IncumbentClient incumbentClient)
    {
        _mapper = mapper;
        _configuration = configuration;
        _logger = logger;
        _incumbentClient = incumbentClient;
    }

    public async Task<List<FileLogDto>> GetFilesByIds(List<int> fileIds)
    {
        try
        {
            _logger.LogInformation($"\nCalling Incumbent gRPC service to get files by ids: {string.Join(", ", fileIds)}\n");

            var request = new FileIdsRequest();
            request.FileIds.AddRange(fileIds);

            var incumbentResponse = await _incumbentClient.ListFilesByIdsAsync(request);

            _logger.LogInformation($"\nSuccessful service response.\n");

            return _mapper.Map<List<FileLogDto>>(incumbentResponse.Files?.ToList());
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    public async Task<byte[]?> ConvertHtmlListToUniquePdfFile(List<string> htmlStringList)
    {
        try
        {
            _logger.LogInformation($"\nConverting HTML to PDF\n");

            var licenseKey = _configuration["IronPdf_LicenseKey"];
            License.LicenseKey = licenseKey;

            //Base 64 String list for all the files generated
            var base64FileList = new List<byte[]>();

            // Margin value
            var defaultMarginValue = 0;

            foreach (var htmlString in htmlStringList)
            {

                var renderer = new ChromePdfRenderer();

                // Page options
                renderer.RenderingOptions.PaperOrientation = IronPdf.Rendering.PdfPaperOrientation.Landscape;
                renderer.RenderingOptions.SetCustomPaperSizeinPixelsOrPoints(1280, 1648);
                renderer.RenderingOptions.MarginBottom = defaultMarginValue;
                renderer.RenderingOptions.MarginLeft = defaultMarginValue;
                renderer.RenderingOptions.MarginRight = defaultMarginValue;
                renderer.RenderingOptions.MarginTop = defaultMarginValue;

                var pdfFile = renderer.RenderHtmlAsPdf(htmlString);

                base64FileList.Add(pdfFile.BinaryData);
            }

            if (base64FileList.Any())
            {
                // First page
                using var finalPdf = new PdfDocument(base64FileList.First());

                // First item is not needed anymore
                base64FileList.RemoveAt(0);

                //To create a pdf with multiple pages
                base64FileList.ForEach(b =>
                {
                    using var newPdfPage = new PdfDocument(b);

                    finalPdf.AppendPdf(newPdfPage);
                });

                return await Task.FromResult(finalPdf.BinaryData);
            }

            return await Task.FromResult(null as byte[]);
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    public async Task<UploadMarketPricingSheetPdfFileDto> UploadMarketPricingSheetPdfFile(byte[] file, int projectVersionId, int? marketPricingSheetId, int organizationId, string organizationName)
    {
        try
        {
            var marketPricingSheetInfo = marketPricingSheetId.HasValue ? $"and Market Pricing Sheet Id {marketPricingSheetId.Value}" : string.Empty;
            _logger.LogInformation($"\nCalling Incumbent gRPC service to upload pdf file for Project Version Id {projectVersionId} {marketPricingSheetInfo}\n");

            var request = new UploadMarketPricingSheetPdfFileRequest
            {
                File = Google.Protobuf.ByteString.CopyFrom(file),
                OrganizationId = organizationId,
                OrganizationName = organizationName,
                ProjectVersionId = projectVersionId,
                ReportDate = Timestamp.FromDateTime(DateTime.Now.ToUniversalTime()),
                MarketPricingSheetId = marketPricingSheetId ?? 0,
            };

            var incumbentResponse = await _incumbentClient.UploadMarketPricingSheetPdfFileAsync(request);

            _logger.LogInformation($"\nSuccessful service response.\n");

            return _mapper.Map<UploadMarketPricingSheetPdfFileDto>(incumbentResponse);
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }
}