
using CN.Incumbent.Domain;
using AutoMapper;
using CN.Incumbent.Domain.Models.Dtos;

namespace CN.Incumbent.Infrastructure
{
    public class MappingConfig
    {
        public static MapperConfiguration RegisterMaps()
        {
            var mappingConfig = new MapperConfiguration(config =>
            {
                config.CreateMap<string, string>().ConvertUsing(str => str == null ? null : str.Trim());

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

                config.CreateMap<FileLogDetail, FileLogDetailDto>()
                .ForMember(dest => dest.FileLogDetailKey, opt => opt.MapFrom(src => src.FileLogDetailKey))
                .ForMember(dest => dest.FileLogKey, opt => opt.MapFrom(src => src.FileLogKey))
                .ForMember(dest => dest.MessageText, opt => opt.MapFrom(src => src.MessageText))
                .ForMember(dest => dest.CreatedUtcDatetime, opt => opt.MapFrom(src => src.CreatedUtcDatetime))
                .ReverseMap();
            });

            return mappingConfig;
        }
    }
}
