using AutoMapper;
using Cn.Incumbent;
using Cn.Organization;
using Cn.Survey;
using CN.Project.Domain;
using CN.Project.Domain.Dto;
using CN.Project.Domain.Enum;
using CN.Project.Domain.Models;
using CN.Project.Domain.Models.Dto;
using CN.Project.Domain.Models.Dto.MarketPricingSheet;
using Google.Protobuf.WellKnownTypes;
using static Cn.Incumbent.ClientBasePayResponse.Types;

namespace CN.Project.Infrastructure
{
    public class MappingConfig
    {
        public static MapperConfiguration RegisterMaps()
        {
            var mappingConfig = new MapperConfiguration(config =>
            {
                config.CreateMap<string, string>().ConvertUsing(str => str == null ? null : str.Trim());

                config.CreateMap<ProjectDto, Project_List>().
                ForMember(dest => dest.Project_Name,
                    opt =>
                    {
                        opt.MapFrom(src => src.Name);
                    }).
                ForMember(dest => dest.Project_Id,
                    opt =>
                    {
                        opt.MapFrom(src => src.Id);
                    }).ReverseMap();

                config.CreateMap<Project_List, SearchProjectDto>().
                    ForMember(dest => dest.Name,
                    opt =>
                    {
                        opt.MapFrom(src => src.Project_Name);
                    }).
                    ForMember(dest => dest.Id,
                    opt =>
                    {
                        opt.MapFrom(src => src.Project_Id);
                    }).
                     ForMember(dest => dest.OrganizationId,
                    opt =>
                    {
                        opt.MapFrom(src => src.Org_Key);
                    }).

                     ForMember(dest => dest.Status,
                    opt =>
                    {
                        opt.MapFrom(src => src.Status_Name);
                    }).
                     ForMember(dest => dest.ProjectVersion,
                    opt =>
                    {
                        opt.MapFrom(src => src.Project_Version_Id);
                    }).
                     ForMember(dest => dest.ProjectVersionLabel,
                    opt =>
                    {
                        opt.MapFrom(src => src.Project_Version_Label);
                    }).
                     ForMember(dest => dest.ProjectVersionDate,
                    opt =>
                    {
                        opt.MapFrom(src => src.Project_Version_Datetime);
                    }).
                    ForMember(dest => dest.DataEffectiveDate,
                    opt =>
                    {
                        opt.MapFrom(src => src.Data_Effective_Date);
                    }).
                    ForMember(dest => dest.SourceData,
                    opt =>
                    {
                        opt.MapFrom(src => src.Source_Data_Name);
                    }).
                     ForMember(dest => dest.AggregationMethodologyKey,
                    opt =>
                    {
                        opt.MapFrom(src => src.Aggregation_Methodology_Key);
                    }).
                    ForMember(dest => dest.WorkForceProjectType,
                    opt =>
                    {
                        opt.MapFrom(src => src.Survey_Source_Group_Key);
                    }).
                    ForMember(dest => dest.FileLogKey,
                    opt =>
                    {
                        opt.MapFrom(src => src.File_Log_Key);
                    })
                .ReverseMap();

                config.CreateMap<ProjectVersionDto, Project_Version>().
                ForMember(dest => dest.Project_version_id,
                    opt =>
                    {
                        opt.MapFrom(src => src.Id);
                    }).
                ForMember(dest => dest.Project_version_label,
                    opt =>
                    {
                        opt.MapFrom(src => src.VersionLabel);
                    }).
                ForMember(dest => dest.File_log_key,
                    opt =>
                    {
                        opt.MapFrom(src => src.FileLogKey);
                    }).
                ForMember(dest => dest.Aggregation_methodology_key,
                    opt =>
                    {
                        opt.MapFrom(src => src.AggregationMethodologyKey);
                    })
                .ReverseMap();

                config.CreateMap<ProjectDetails, ProjectDetailsDto>().
               ForMember(dest => dest.ID,
                   opt =>
                   {
                       opt.MapFrom(src => src.project_id);
                   }).
               ForMember(dest => dest.Name,
                   opt =>
                   {
                       opt.MapFrom(src => src.project_name);
                   }).
                    ForMember(dest => dest.OrganizationID,
                   opt =>
                   {
                       opt.MapFrom(src => src.org_key);
                   }).
                   ForMember(dest => dest.ProjectStatus,
                   opt =>
                   {
                       opt.MapFrom(src => src.project_status_key);
                   })
               .ReverseMap();

                config.CreateMap<OrganizationDto, CN.Project.Domain.Organization>().ReverseMap();

                // Protobuf mapping
                config.CreateMap<OrganizationDto, OrganizationModel>().
                ForMember(dest => dest.OrgId,
                    opt =>
                    {
                        opt.MapFrom(src => src.Id);
                    }).
                ForMember(dest => dest.OrgName,
                    opt =>
                    {
                        opt.MapFrom(src => src.Name);
                    })
                .ReverseMap();

                config.CreateMap<SurveyCutListResponse, SurveyCutDto>().
                ForMember(dest => dest.SurveyYears,
                    opt =>
                    {
                        opt.MapFrom(src => src.SurveyNameKeysets.SelectMany(s => s.FilterKeyYear).Select(s => new SurveyYearDto { SurveyKey = s.FilterKey, SurveyYear = s.SurveyYear }));
                    }).
                ForMember(dest => dest.Publishers,
                    opt =>
                    {
                        opt.MapFrom(src => src.SurveyPublisherNameKeysets.Select(p => new NameKeyDto { Name = p.FilterName, Keys = p.FilterKeyYear.Select(fky => fky.FilterKey) }));
                    }).
                ForMember(dest => dest.Surveys,
                    opt =>
                    {
                        opt.MapFrom(src => src.SurveyNameKeysets.Select(s => new NameKeyDto { Name = s.FilterName, Keys = s.FilterKeyYear.Select(fky => fky.FilterKey) }));
                    }).
                ForMember(dest => dest.Industries,
                    opt =>
                    {
                        opt.MapFrom(src => src.IndustrySectorNameKeysets.Select(i => new NameKeyDto { Name = i.FilterName, Keys = i.FilterKeyYear.Select(fky => fky.FilterKey) }));
                    }).
                ForMember(dest => dest.Organizations,
                    opt =>
                    {
                        opt.MapFrom(src => src.OrganizationTypeNameKeysets.Select(o => new NameKeyDto { Name = o.FilterName, Keys = o.FilterKeyYear.Select(fky => fky.FilterKey) }));
                    }).
                ForMember(dest => dest.CutGroups,
                    opt =>
                    {
                        opt.MapFrom(src => src.CutGroupNameKeysets.Select(cg => new NameKeyDto { Name = cg.FilterName, Keys = cg.FilterKeyYear.Select(fky => fky.FilterKey) }));
                    }).
                ForMember(dest => dest.CutSubGroups,
                    opt =>
                    {
                        opt.MapFrom(src => src.CutSubGroupNameKeysets.Select(cs => new NameKeyDto { Name = cs.FilterName, Keys = cs.FilterKeyYear.Select(fky => fky.FilterKey) }));
                    }).
                ForMember(dest => dest.Cuts,
                    opt =>
                    {
                        opt.MapFrom(src => src.CutNameKeysets.Select(p => new NameKeyDto { Name = p.FilterName, Keys = p.FilterKeyYear.Select(fky => fky.FilterKey) }));
                    })
                .ReverseMap();

                config.CreateMap<Project_List, ProjectDetailsViewDto>()
                    .ForMember(dest => dest.ID, opt => opt.MapFrom(src => src.Project_Id))
                    .ForMember(dest => dest.Name, opt => opt.MapFrom(src => src.Project_Name))
                    .ForMember(dest => dest.OrganizationID, opt => opt.MapFrom(src => src.Org_Key))
                    .ForMember(dest => dest.Version, opt => opt.MapFrom(src => src.Project_Version_Id))
                    .ForMember(dest => dest.VersionLabel, opt => opt.MapFrom(src => src.Project_Version_Label))
                    .ForMember(dest => dest.VersionDate, opt => opt.MapFrom(src => src.Project_Version_Datetime))
                    .ForMember(dest => dest.AggregationMethodologyKey, opt => opt.MapFrom(src => src.Aggregation_Methodology_Key))
                    .ForMember(dest => dest.WorkforceProjectType, opt => opt.MapFrom(src => src.Survey_Source_Group_Key))
                    .ForMember(dest => dest.ProjectStatus, opt => opt.MapFrom(src => src.Project_Version_Status_Key))
                    .ForMember(dest => dest.VersionStatusNotes, opt => opt.MapFrom(src => src.Project_Version_Status_Notes))
                    .ForMember(dest => dest.FileLogKey, opt => opt.MapFrom(src => src.File_Log_Key))
                    .ReverseMap();

                config.CreateMap<BenchmarkDataType, BenchmarkDataTypeInfoDto>()
                    .ForMember(dest => dest.ID, opt => opt.MapFrom(src => src.Project_benchmark_data_type_id))
                    .ForMember(dest => dest.BenchmarkDataTypeKey, opt => opt.MapFrom(src => src.Benchmark_data_type_key))
                    .ForMember(dest => dest.OverrideAgingFactor, opt => opt.MapFrom(src => src.Aging_factor_override))
                    .ForMember(dest => dest.OverrideNote, opt => opt.MapFrom(src => src.Override_comment))
                    .ReverseMap();


                config.CreateMap<FileLogDto, SourceDataInfoDto>()
                    .ForMember(dest => dest.EffectiveDate, opt => opt.MapFrom(src => src.EffectiveDate))
                    .ForMember(dest => dest.SourceData, opt => opt.MapFrom(src => src.SourceDataName))
                    .ForMember(dest => dest.FileLogKey, opt => opt.MapFrom(src => src.FileLogKey))
                    .ForMember(dest => dest.SourceDataType, opt => opt.MapFrom(src => src.SourceDataType))
                    .ReverseMap();

                config.CreateMap<MarketSegmentList, MarketSegmentDto>()
                    .ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.MarketSegmentId))
                    .ForMember(dest => dest.Name, opt => opt.MapFrom(src => src.MarketSegmentName))
                    .ForMember(dest => dest.ProjectVersionId, opt => opt.MapFrom(src => src.ProjectVersionId))
                    .ForMember(dest => dest.Status, opt => opt.MapFrom(src => src.MarketSegmentStatusKey))
                    .ForMember(dest => dest.EriAdjustmentFactor, opt => opt.MapFrom(src => src.EriAdjustmentFactor))
                    .ForMember(dest => dest.EriCutName, opt => opt.MapFrom(src => src.EriCutName))
                    .ForMember(dest => dest.EriCity, opt => opt.MapFrom(src => src.EriCity))
                    .ReverseMap();

                config.CreateMap<MarketSegmentCut, MarketSegmentCutDto>()
                    .ForMember(dest => dest.MarketSegmentCutKey, opt => opt.MapFrom(src => src.MarketSegmentCutKey))
                    .ForMember(dest => dest.CutName, opt => opt.MapFrom(src => src.MarketPricingCutName))
                    .ForMember(dest => dest.MarketSegmentId, opt => opt.MapFrom(src => src.MarketSegmentId))
                    .ForMember(dest => dest.BlendFlag, opt => opt.MapFrom(src => src.IsBlendFlag))
                    .ForMember(dest => dest.IndustrySectorKey, opt => opt.MapFrom(src => src.IndustrySectorKey))
                    .ForMember(dest => dest.OrganizationTypeKey, opt => opt.MapFrom(src => src.OrganizationTypeKey))
                    .ForMember(dest => dest.CutGroupKey, opt => opt.MapFrom(src => src.CutGroupKey))
                    .ForMember(dest => dest.CutSubGroupKey, opt => opt.MapFrom(src => src.CutSubGroupKey))
                    .ForMember(dest => dest.DisplayOnReport, opt => opt.MapFrom(src => src.DisplayOnReportFlag))
                    .ForMember(dest => dest.ReportOrder, opt => opt.MapFrom(src => src.ReportOrder))
                    .ReverseMap();

                config.CreateMap<MarketSegmentCutDetail, MarketSegmentCutDetailDto>()
                    .ForMember(dest => dest.MarketSegmentCutDetailKey, opt => opt.MapFrom(src => src.MarketSegmentCutDetailKey))
                    .ForMember(dest => dest.MarketSegmentCutKey, opt => opt.MapFrom(src => src.MarketSegmentCutKey))
                    .ForMember(dest => dest.PublisherKey, opt => opt.MapFrom(src => src.PublisherKey))
                    .ForMember(dest => dest.SurveyKey, opt => opt.MapFrom(src => src.SurveyKey))
                    .ForMember(dest => dest.IndustrySectorKey, opt => opt.MapFrom(src => src.IndustrySectorKey))
                    .ForMember(dest => dest.OrganizationTypeKey, opt => opt.MapFrom(src => src.OrganizationTypeKey))
                    .ForMember(dest => dest.CutGroupKey, opt => opt.MapFrom(src => src.CutGroupKey))
                    .ForMember(dest => dest.CutSubGroupKey, opt => opt.MapFrom(src => src.CutSubGroupKey))
                    .ForMember(dest => dest.CutKey, opt => opt.MapFrom(src => src.CutKey))
                    .ForMember(dest => dest.Selected, opt => opt.MapFrom(src => src.Selected))
                    .ReverseMap();

                config.CreateMap<FileModel, FileLogDto>()
                    .ForMember(dest => dest.FileLogKey, opt => opt.MapFrom(src => src.FileLogKey))
                    .ForMember(dest => dest.OrganizationId, opt => opt.MapFrom(src => src.FileOrgKey))
                    .ForMember(dest => dest.SourceDataName, opt => opt.MapFrom(src => src.SourceDataName))
                    .ForMember(dest => dest.EffectiveDate, opt => opt.MapFrom(src => src.DataEffectiveDate.ToDateTime()))
                    .ForMember(dest => dest.FileStatusKey, opt => opt.MapFrom(src => src.FileStatusKey))
                    .ForMember(dest => dest.FileStatusName, opt => opt.MapFrom(src => src.StatusName));

                config.CreateMap<MarketSegmentBlend, MarketSegmentBlendCutDto>()
                    .ForMember(dest => dest.MarketSegmentBlendKey, opt => opt.MapFrom(src => src.MarketSegmentBlendKey))
                    .ForMember(dest => dest.ParentMarketSegmentCutKey, opt => opt.MapFrom(src => src.ParentMarketSegmentCutKey))
                    .ForMember(dest => dest.ChildMarketSegmentCutKey, opt => opt.MapFrom(src => src.ChildMarketSegmentCutKey))
                    .ForMember(dest => dest.BlendWeight, opt => opt.MapFrom(src => src.BlendWeight))
                    .ReverseMap();

                config.CreateMap<SourceDataModel, JobDto>()
                    .ForMember(dest => dest.SourceDataAgregationKey, opt => opt.MapFrom(src => src.SourceDataAgregationKey))
                    .ForMember(dest => dest.AggregationMethodKey, opt => opt.MapFrom(src => src.AggregationMethodKey))
                    .ForMember(dest => dest.FileLogKey, opt => opt.MapFrom(src => src.FileLogKey))
                    .ForMember(dest => dest.FileOrgKey, opt => opt.MapFrom(src => src.AggregationMethodKey == (int)AggregationMethodology.Parent ? src.FileOrgKey : src.CesOrgId))
                    .ForMember(dest => dest.JobCode, opt => opt.MapFrom(src => src.JobCode))
                    .ForMember(dest => dest.JobTitle, opt => opt.MapFrom(src => src.JobTitle))
                    .ForMember(dest => dest.IncumbentCount, opt => opt.MapFrom(src => src.IncumbentCount))
                    .ForMember(dest => dest.FteCount, opt => opt.MapFrom(src => src.FteValue))
                    .ForMember(dest => dest.LocationDescription, opt => opt.MapFrom(src => src.LocationDescription))
                    .ForMember(dest => dest.JobFamily, opt => opt.MapFrom(src => src.JobFamily))
                    .ForMember(dest => dest.PayGrade, opt => opt.MapFrom(src => src.PayGrade))
                    .ForMember(dest => dest.PayType, opt => opt.MapFrom(src => src.PayType))
                    .ForMember(dest => dest.PositionCode, opt => opt.MapFrom(src => src.PositionCode))
                    .ForMember(dest => dest.PositionCodeDescription, opt => opt.MapFrom(src => src.PositionCodeDescription))
                    .ForMember(dest => dest.JobLevel, opt => opt.MapFrom(src => src.JobLevel))
                    .ForMember(dest => dest.JobGroup, opt => opt.MapFrom(src => src.ClientJobGroup))
                    .ReverseMap();

                config.CreateMap<BenchmarkDataTypeDto, BenchmarkDataTypeListResponse.Types.BenchmarkDataTypeResponse>()
                    .ForMember(dest => dest.BenchmarkDataTypeKey, opt => opt.MapFrom(src => src.Id))
                    .ForMember(dest => dest.BenchmarkDataTypeName, opt => opt.MapFrom(src => src.Name))
                    .ForMember(dest => dest.AgingFactorDefault, opt => opt.MapFrom(src => src.AgingFactor))
                    .ForMember(dest => dest.BenchmarkDataTypeDefault, opt => opt.MapFrom(src => src.DefaultDataType))
                    .ReverseMap();

                config.CreateMap<MarketPercentileDto, MarketPercentileSet>()
                    .ForMember(dest => dest.MarketValue, opt => opt.MapFrom(src => src.MarketValue))
                    .ForMember(dest => dest.Percentile, opt => opt.MapFrom(src => src.Percentile))
                    .ReverseMap();

                config.CreateMap<ClientPayDto, ClientBasePay>()
                    .ForMember(dest => dest.JobCode, opt => opt.MapFrom(src => src.JobCode))
                    .ForMember(dest => dest.BenchmarkDataTypeKey, opt => opt.MapFrom(src => src.BenchmarkDataTypeKey))
                    .ForMember(dest => dest.BenchmarkDataTypeValue, opt => opt.MapFrom(src => src.BenchmarkDataTypeValue))
                    .ReverseMap();

                config.CreateMap<SourceDataModel, MarketPricingSheetDto>()
                    .ForMember(dest => dest.AggregationMethodKey, opt => opt.MapFrom(src => src.AggregationMethodKey))
                    .ForMember(dest => dest.FileOrgKey, opt => opt.MapFrom(src => src.AggregationMethodKey == (int)AggregationMethodology.Parent ? src.FileOrgKey : src.CesOrgId))
                    .ForMember(dest => dest.JobCode, opt => opt.MapFrom(src => src.JobCode))
                    .ForMember(dest => dest.JobTitle, opt => opt.MapFrom(src => src.JobTitle))
                    .ForMember(dest => dest.PositionCode, opt => opt.MapFrom(src => src.PositionCode))
                    .ForMember(dest => dest.JobGroup, opt => opt.MapFrom(src => src.ClientJobGroup))
                    .ReverseMap();

                config.CreateMap<ClientPayDto, ClientPayDetail>()
                   .ForMember(dest => dest.BenchmarkDataTypeKey, opt => opt.MapFrom(src => src.BenchmarkDataTypeKey))
                   .ForMember(dest => dest.BenchmarkDataTypeValue, opt => opt.MapFrom(src => src.BenchmarkDataTypeValue))
                   .ReverseMap();

                config.CreateMap<SurveyCutsDataListResponse.Types.SurveyCutsDataResponse, SurveyCutDataDto>()
                    .ForMember(dest => dest.SurveyPublisherKey, opt => opt.MapFrom(src => src.SurveyPublisherKey))
                    .ForMember(dest => dest.SurveyPublisherName, opt => opt.MapFrom(src => src.SurveyPublisherName))
                    .ForMember(dest => dest.SurveyKey, opt => opt.MapFrom(src => src.SurveyKey))
                    .ForMember(dest => dest.SurveyYear, opt => opt.MapFrom(src => src.SurveyYear))
                    .ForMember(dest => dest.SurveyName, opt => opt.MapFrom(src => src.SurveyName))
                    .ForMember(dest => dest.SurveyCode, opt => opt.MapFrom(src => src.SurveyCode))
                    .ForMember(dest => dest.SurveyPublisherKey, opt => opt.MapFrom(src => src.SurveyPublisherKey))
                    .ForMember(dest => dest.SurveyPublisherName, opt => opt.MapFrom(src => src.SurveyPublisherName))
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
                    .ForMember(dest => dest.SurveyDataEffectiveDate, opt => opt.MapFrom(src => src.SurveyDataEffectiveDate.ToDateTime()))
                    .ForMember(dest => dest.MarketValueByPercentile, opt => opt.MapFrom(src => src.MarketValueByPercentile))
                    .ReverseMap();

                config.CreateMap<UploadMarketPricingSheetPdfFileResponse, UploadMarketPricingSheetPdfFileDto>()
                    .ForMember(dest => dest.Success, opt => opt.MapFrom(src => src.Success))
                    .ForMember(dest => dest.Message, opt => opt.MapFrom(src => src.Message))
                    .ForMember(dest => dest.FileS3Url, opt => opt.MapFrom(src => src.FileS3Url))
                    .ForMember(dest => dest.FileS3Name, opt => opt.MapFrom(src => src.FileS3Name))
                    .ReverseMap();

                config.CreateMap<SourceDataEmployeeModel, JobEmployeeDto>();
            });

            return mappingConfig;
        }
    }
}