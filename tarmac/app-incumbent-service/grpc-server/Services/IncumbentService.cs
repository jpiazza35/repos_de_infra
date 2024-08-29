using AutoMapper;
using Cn.Incumbent.V1;
using CN.Incumbent.Domain;
using CN.Incumbent.Domain.Models.Dtos;
using Grpc.Core;
using static Cn.Incumbent.V1.ClientBasePayResponse.Types;

namespace CN.Organization.GrpcServer
{
    public class IncumbentService : Cn.Incumbent.V1.Incumbent.IncumbentBase
    {
        private readonly ILogger<IncumbentService> _logger;
        private readonly IFileRepository _fileRepository;
        private readonly ISourceDataRepository _sourceDataRepository;
        protected IMapper _mapper;

        public IncumbentService(IFileRepository organizationRepository,
                                ISourceDataRepository sourceDataRepository,
                                IMapper mapper,
                                ILogger<IncumbentService> logger)
        {
            _fileRepository = organizationRepository;
            _sourceDataRepository = sourceDataRepository;
            _mapper = mapper;
            _logger = logger;
        }

        public override async Task<FileList> ListFilesByIds(FileIdsRequest request, ServerCallContext context)
        {
            _logger.LogInformation($"\nIncumbent gRPC service called with request: {request} \n");

            var files = await _fileRepository.GetFilesByIds(request.FileIds.ToList());

            if (files is null || !files.Any())
                return new FileList();

            var filesModel = _mapper.Map<List<FileModel>>(files);
            return new FileList
            {
                Files = { filesModel }
            };
        }

        public override async Task<SourceDataList> ListSourceData(SourceDataSearchRequest request, ServerCallContext context)
        {
            _logger.LogInformation($"\nIncumbent gRPC service called with request: {request} \n");

            var sourceDataJobs = await _sourceDataRepository.ListSourceData(request.FileLogKey, request.AggregationMethodKey);

            if (sourceDataJobs is null || !sourceDataJobs.Any())
                return new SourceDataList();

            var sourceDataModel = _mapper.Map<List<SourceDataModel>>(sourceDataJobs);
            return new SourceDataList
            {
                ClientJobs = { sourceDataModel }
            };
        }

        public override async Task<SourceDataEmployeeLevelList> ListSourceDataEmployeeLevel(SourceDataSearchRequest request, ServerCallContext context)
        {
            _logger.LogInformation($"\nIncumbent gRPC service called with request: {request} \n");
            var result = new SourceDataEmployeeLevelList();
            var data = await _sourceDataRepository.ListSourceDataEmployeeLevel(request.FileLogKey);

            if (data is not null && data.Any())
            {
                var Employees = _mapper.Map<List<SourceDataEmployeeModel>>(data);
                result.Employees.AddRange(Employees);
            }
            
            return result;
        }

        public override async Task<ClientBasePayResponse> ListClientBasePay(ClientBasePayRequest request, ServerCallContext context)
        {
            _logger.LogInformation($"\nIncumbent gRPC service called with request: {request} \n");

            var clientBasePay = await _sourceDataRepository.ListClientBasePay(request.FileLogKey, request.AggregationMethodKey, request.JobCodes, request.BenchmarkDataTypeKeys);

            if (clientBasePay is null || !clientBasePay.Any())
                return new ClientBasePayResponse();

            var clientBasePayList = _mapper.Map<List<ClientBasePay>>(clientBasePay);

            return new ClientBasePayResponse
            {
                ClientBasePayLists = { clientBasePayList }
            };
        }

        public override async Task<SourceDataList> ListClientJobs(SourceDataSearchRequest request, ServerCallContext context)
        {
            _logger.LogInformation($"\nIncumbent gRPC service called with request: {request} \n");

            var sourceDataJobs = await _sourceDataRepository.ListClientJobs(request.FileLogKey, request.AggregationMethodKey);

            if (sourceDataJobs is null || !sourceDataJobs.Any())
                return new SourceDataList();

            var sourceDataModel = _mapper.Map<List<SourceDataModel>>(sourceDataJobs);
            return new SourceDataList
            {
                ClientJobs = { sourceDataModel }
            };
        }

        public override async Task<ClientPayDetailResponse> ListClientPayDetail(ClientJobRequest request, ServerCallContext context)
        {
            _logger.LogInformation($"\nIncumbent gRPC service called with request: {request} \n");

            var clientPayDetails = await _sourceDataRepository.ListClientPayDetail(request.FileLogKey,
                request.FileOrgKey,
                request.AggregationMethodKey,
                request.JobCode,
                request.PositionCode,
                request.BenchmarkDataTypeKeys);

            if (clientPayDetails is null || !clientPayDetails.Any())
                return new ClientPayDetailResponse();

            var clientPayDetailsModel = _mapper.Map<List<ClientPayDetail>>(clientPayDetails);
            return new ClientPayDetailResponse
            {
                ClientPayDetails = { clientPayDetailsModel }
            };
        }

        public override async Task<UploadMarketPricingSheetPdfFileResponse> UploadMarketPricingSheetPdfFile(UploadMarketPricingSheetPdfFileRequest request, ServerCallContext context)
        {
            _logger.LogInformation($"\nIncumbent gRPC service called with request: {request} \n");

            var marketPricingSheetPdfDto = new MarketPricingSheetPdfDto
            {
                OrganizationId = request.OrganizationId,
                OrganizationName = request.OrganizationName,
                ProjectVersionId = request.ProjectVersionId,
                ReportDate = request.ReportDate.ToDateTime(),
                MarketPricingSheetId = request.MarketPricingSheetId
            };

            var response = await _fileRepository.UploadMarketPricingSheetPdfFile(request.File.ToByteArray(), marketPricingSheetPdfDto);

            return new UploadMarketPricingSheetPdfFileResponse
            {
                Success = response.Success,
                Message = response.Message ?? string.Empty,
                FileS3Url = response.FileS3Url ?? string.Empty,
                FileS3Name = response.FileS3Name ?? string.Empty,
            };
        }

        public override async Task<SourceDataList> ListClientPositionDetail(ClientJobRequest request, ServerCallContext context)
        {
            _logger.LogInformation($"\nIncumbent gRPC service called with request: {request} \n");

            var clientJobDetail = await _sourceDataRepository.ListClientPositionDetail(request.FileLogKey, 
                                                                           request.AggregationMethodKey, 
                                                                           request.JobCode, 
                                                                           request.PositionCode, 
                                                                           request.FileOrgKey);
            if (clientJobDetail is null || !clientJobDetail.Any())
                return new SourceDataList();

            var sourceDataModel = _mapper.Map<List<SourceDataModel>>(clientJobDetail);
            return new SourceDataList
            {
                ClientJobs = { sourceDataModel }
            };
        }
    }
}
