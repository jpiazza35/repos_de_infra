using AutoMapper;
using Cn.Incumbent.V1;
using CN.Incumbent.Domain;
using CN.Incumbent.Domain.Models.Dtos;
using Google.Protobuf.WellKnownTypes;
using static Cn.Incumbent.V1.ClientBasePayResponse.Types;

namespace CN.Incumbent.GrpcServer
{
    public class MappingConfig
    {
        public static MapperConfiguration RegisterMaps()
        {
            var mappingConfig = new MapperConfiguration(config =>
            {
                config.CreateMap<string, string>().ConvertUsing(str => (str ?? "").Trim());

                config.CreateMap<FileLog, FileLogDto>()
                .ForMember(dest => dest.FileLogKey, opt => opt.MapFrom(src => src.FileLogKey))
                .ForMember(dest => dest.OrganizationId, opt => opt.MapFrom(src => src.FileOrgKey))
                .ForMember(dest => dest.SourceDataName, opt => opt.MapFrom(src => src.SourceDataName))
                .ForMember(dest => dest.EffectiveDate, opt => opt.MapFrom(src => src.DataEffectiveDate))
                .ForMember(dest => dest.ClientFileName, opt => opt.MapFrom(src => src.ClientFileName))
                .ForMember(dest => dest.FileS3Name, opt => opt.MapFrom(src => src.FileS3Name))
                .ForMember(dest => dest.FileS3Url, opt => opt.MapFrom(src => src.FileS3Url))
                .ForMember(dest => dest.UploadedBy, opt => opt.MapFrom(src => src.UploadedBy))
                .ForMember(dest => dest.UploadedUtcDatetime, opt => opt.MapFrom(src => src.UploadedUtcDatetime))
                .ForMember(dest => dest.FileStatusKey, opt => opt.MapFrom(src => src.FileStatusKey))
                .ForMember(dest => dest.FileStatusName, opt => opt.MapFrom(src => src.FileStatusName))
                .ReverseMap();

                config.CreateMap<FileLogDto, FileModel>()
                .ForMember(dest => dest.FileLogKey, opt => opt.MapFrom(src => src.FileLogKey))
                .ForMember(dest => dest.FileOrgKey, opt => opt.MapFrom(src => src.OrganizationId))
                .ForMember(dest => dest.SourceDataName, opt => opt.MapFrom(src => src.SourceDataName))
                .ForMember(dest => dest.DataEffectiveDate, opt => opt.MapFrom(src => Timestamp.FromDateTime(src.EffectiveDate.ToUniversalTime())))
                .ForMember(dest => dest.FileStatusKey, opt => opt.MapFrom(src => src.FileStatusKey))
                .ForMember(dest => dest.StatusName, opt => opt.MapFrom(src => src.FileStatusName))
                .ReverseMap();

                config.CreateMap<SourceData, SourceDataModel>()
                .ForMember(dest => dest.SourceDataAgregationkey, opt => opt.MapFrom(src => src.SourceDataAgregationKey))
                .ForMember(dest => dest.AggregationMethodKey, opt => opt.MapFrom(src => src.AggregationMethodKey))
                .ForMember(dest => dest.FileLogKey, opt => opt.MapFrom(src => src.FileLogKey))
                .ForMember(dest => dest.FileOrgKey, opt => opt.MapFrom(src => src.FileOrgKey))
                .ForMember(dest => dest.CesOrgId, opt => opt.MapFrom(src => src.CesOrgId))
                .ForMember(dest => dest.JobCode, opt => opt.MapFrom(src => src.JobCode))
                .ForMember(dest => dest.JobTitle, opt => opt.MapFrom(src => src.JobTitle))
                .ForMember(dest => dest.IncumbentCount, opt => opt.MapFrom(src => src.IncumbentCount))
                .ForMember(dest => dest.FteValue, opt => opt.MapFrom(src => src.FteValue))
                .ForMember(dest => dest.LocationDescription, opt => opt.MapFrom(src => src.LocationDescription))
                .ForMember(dest => dest.JobFamily, opt => opt.MapFrom(src => src.JobFamily))
                .ForMember(dest => dest.PayGrade, opt => opt.MapFrom(src => src.PayGrade))
                .ForMember(dest => dest.PayType, opt => opt.MapFrom(src => src.PayType))
                .ForMember(dest => dest.PositionCode, opt => opt.MapFrom(src => src.PositionCode))
                .ForMember(dest => dest.PositionCodeDescription, opt => opt.MapFrom(src => src.PositionCodeDescription))
                .ForMember(dest => dest.JobLevel, opt => opt.MapFrom(src => src.JobLevel))
                .ForMember(dest => dest.ClientJobGroup, opt => opt.MapFrom(src => src.ClientJobGroup))
                .ForMember(dest => dest.MarketSegmentName, opt => opt.MapFrom(src => src.MarketSegmentName))
                .ForMember(dest => dest.BenchmarkDataTypes, opt => opt.MapFrom(src => src.BenchmarkDataTypes))
                .ReverseMap();

                config.CreateMap<SourceData, ClientBasePay>()
                .ForMember(dest => dest.JobCode, opt => opt.MapFrom(src => src.JobCode))
                .ForMember(dest => dest.BenchmarkDataTypeKey, opt => opt.MapFrom(src => src.BenchmarkDataTypeKey))
                .ForMember(dest => dest.BenchmarkDataTypeValue, opt => opt.MapFrom(src => src.BenchmarkDataTypeValue))
                .ReverseMap();

                config.CreateMap<SourceData, ClientPayDetail>()
                .ForMember(dest => dest.BenchmarkDataTypeKey, opt => opt.MapFrom(src => src.BenchmarkDataTypeKey))
                .ForMember(dest => dest.BenchmarkDataTypeValue, opt => opt.MapFrom(src => src.BenchmarkDataTypeValue))
                .ReverseMap();

                config.CreateMap<SourceDataEmployeeLevel, SourceDataEmployeeModel>()
                .ForMember(dest => dest.OriginalHireDate, opt => opt.MapFrom(src => src.OriginalHireDate.HasValue ? src.OriginalHireDate.Value.ToString() : string.Empty))
                .ForMember(dest => dest.CreditedYoe, opt => opt.MapFrom(src => src.CreditedYoe.HasValue ? src.CreditedYoe.Value.ToString() : string.Empty))
                .ReverseMap();
            });

            return mappingConfig;
        }
    }
}
