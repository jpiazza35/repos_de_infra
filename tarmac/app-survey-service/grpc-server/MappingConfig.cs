using AutoMapper;
using Cn.Survey;
using CN.Survey.Domain;
using Google.Protobuf.WellKnownTypes;
using static Cn.Survey.BenchmarkDataTypeListResponse.Types;

namespace CN.Survey.GrpcServer;

public class MappingConfig
{
    public static MapperConfiguration RegisterMaps()
    {
        var mappingConfig = new MapperConfiguration(config =>
        {
            config.CreateMap<string, string>().ConvertUsing(str => str == null ? null : str.Trim());

            config.CreateMap<BenchmarkDataType, BenchmarkDataTypeResponse>()
            .ForMember(dest => dest.BenchmarkDataTypeKey, opt => opt.MapFrom(src => src.ID))
            .ForMember(dest => dest.BenchmarkDataTypeName, opt => opt.MapFrom(src => src.Name))
            .ForMember(dest => dest.AgingFactorDefault, opt => opt.MapFrom(src => src.AgingFactor))
            .ForMember(dest => dest.BenchmarkDataTypeDefault, opt => opt.MapFrom(src => src.DefaultDataType))
            .ReverseMap();

            config.CreateMap<Domain.Response.MarketPercentileSet, MarketPercentileSet>()
            .ForMember(dest => dest.Percentile, opt => opt.MapFrom(src => src.Percentile))
            .ForMember(dest => dest.MarketValue, opt => opt.MapFrom(src => src.MarketValue))
            .ReverseMap();

            config.CreateMap<Domain.Response.SurveyCutsDataResponse, SurveyCutsDataListResponse.Types.SurveyCutsDataResponse>()
            .ForMember(dest => dest.RawDataKey, opt => opt.MapFrom(src => src.RawDataKey))
            .ForMember(dest => dest.SurveyPublisherKey, opt => opt.MapFrom(src => src.SurveyPublisherKey))
            .ForMember(dest => dest.SurveyPublisherName, opt => opt.MapFrom(src => src.SurveyPublisherName))
            .ForMember(dest => dest.SurveyKey, opt => opt.MapFrom(src => src.SurveyKey))
            .ForMember(dest => dest.SurveyYear, opt => opt.MapFrom(src => src.SurveyYear))
            .ForMember(dest => dest.SurveyName, opt => opt.MapFrom(src => src.SurveyName))
            .ForMember(dest => dest.SurveyCode, opt => opt.MapFrom(src => src.SurveyCode))
            .ForMember(dest => dest.IndustrySectorKey, opt => opt.MapFrom(src => src.IndustrySectorKey))
            .ForMember(dest => dest.IndustrySectorName, opt => opt.MapFrom(src => src.IndustrySectorName))
            .ForMember(dest => dest.OrganizationTypeKey, opt => opt.MapFrom(src => src.OrganizationTypeKey))
            .ForMember(dest => dest.OrganizationTypeName, opt => opt.MapFrom(src => src.OrganizationTypeName))
            .ForMember(dest => dest.CutGroupKey, opt => opt.MapFrom(src => src.CutGroupKey))
            .ForMember(dest => dest.CutGroupName, opt => opt.MapFrom(src => src.CutGroupName))
            .ForMember(dest => dest.CutSubGroupKey, opt => opt.MapFrom(src => src.CutSubGroupKey))
            .ForMember(dest => dest.CutSubGroupName, opt => opt.MapFrom(src => src.CutSubGroupName))
            .ForMember(dest => dest.CutKey, opt => opt.MapFrom(src => src.CutKey))
            .ForMember(dest => dest.CutName, opt => opt.MapFrom(src => src.CutName))
            .ForMember(dest => dest.BenchmarkDataTypeKey, opt => opt.MapFrom(src => src.BenchmarkDataTypeKey))
            .ForMember(dest => dest.BenchmarkDataTypeName, opt => opt.MapFrom(src => src.BenchmarkDataTypeName))
            .ForMember(dest => dest.StandardJobCode, opt => opt.MapFrom(src => src.StandardJobCode))
            .ForMember(dest => dest.StandardJobTitle, opt => opt.MapFrom(src => src.StandardJobTitle))
            .ForMember(dest => dest.SurveySpecialtyCode, opt => opt.MapFrom(src => src.SurveySpecialtyCode))
            .ForMember(dest => dest.SurveySpecialtyName, opt => opt.MapFrom(src => src.SurveySpecialtyName))
            .ForMember(dest => dest.ProviderCount, opt => opt.MapFrom(src => src.ProviderCount))
            .ForMember(dest => dest.FooterNotes, opt => opt.MapFrom(src => src.FooterNotes))
            .ForMember(dest => dest.SurveyDataEffectiveDate, opt => opt.MapFrom(src => Timestamp.FromDateTimeOffset(src.SurveyDataEffectiveDate)))
            .ForMember(dest => dest.MarketValueByPercentile, opt => opt.MapFrom(src => src.MarketValueByPercentile))
            .ReverseMap();
        });

        return mappingConfig;
    }
}
