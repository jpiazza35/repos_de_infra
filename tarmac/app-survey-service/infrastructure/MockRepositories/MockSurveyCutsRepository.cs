using CN.Survey.Domain;
using CN.Survey.Domain.Request;
using CN.Survey.Domain.Response;
using Newtonsoft.Json;

namespace CN.Survey.Infrastructure.MockRepositories
{
    public class MockSurveyCutsRepository : ISurveyCutsRepository
    {
        public async Task<SurveyCutFilterOptionsListResponse> ListSurveyCutFilterOptions(SurveyCutFilterOptionsRequest request)
        {
            var jsonFilePath = "Mocks/survey_cut_filter_options.json";
            var jsonData = System.IO.File.ReadAllText(jsonFilePath);
            var data = DeserializeJson<SurveyYearResponse>(jsonData) ?? new SurveyYearResponse();

            var result = new SurveyCutFilterOptionsListResponse { SurveyYears = new List<SurveyYearResponse> { data } };

            return await Task.FromResult(result);
        }

        public async Task<IEnumerable<SurveyCutFilterFlatOption>> ListSurveyCutFilterFlatOptions(SurveyCutFilterFlatOptionsRequest request)
        {
            var jsonFilePath = "Mocks/survey_cuts.json";
            var jsonData = System.IO.File.ReadAllText(jsonFilePath);
            var data = DeserializeJson<IEnumerable<SurveyCutsDataResponse>>(jsonData);
            var uniqueFilters = new List<SurveyCutFilterFlatOption>();

            switch (request)
            {
                case { Publisher: true }:
                    uniqueFilters = data?.GroupBy(d => d.SurveyPublisherName).Select(d => new SurveyCutFilterFlatOption
                    {
                        Name = d.Key,
                        Keys = d.Where(data => data.SurveyPublisherKey.HasValue).Select(data => data.SurveyPublisherKey).OfType<int>().Distinct()
                    }).ToList();
                    break;
                case { Survey: true }:
                    uniqueFilters = data?.GroupBy(d => d.SurveyName).Select(d => new SurveyCutFilterFlatOption
                    {
                        Name = d.Key,
                        Keys = d.Where(data => data.SurveyKey.HasValue).Select(data => data.SurveyKey).OfType<int>().Distinct()
                    }).ToList();
                    break;
                case { Organization: true }:
                    uniqueFilters = data?.GroupBy(d => d.OrganizationTypeName).Select(d => new SurveyCutFilterFlatOption
                    {
                        Name = d.Key,
                        Keys = d.Where(data => data.OrganizationTypeKey.HasValue).Select(data => data.OrganizationTypeKey).OfType<int>().Distinct()
                    }).ToList();
                    break;
                case { CutGroup: true }:
                    uniqueFilters = data?.GroupBy(d => d.CutGroupName).Select(d => new SurveyCutFilterFlatOption
                    {
                        Name = d.Key,
                        Keys = d.Where(data => data.CutGroupKey.HasValue).Select(data => data.CutGroupKey).OfType<int>().Distinct()
                    }).ToList();
                    break;
                case { CutSubGroup: true }:
                    if (request.CutGroupKeys is not null && request.CutGroupKeys.Any())
                        data = data?.Where(d => d.CutGroupKey.HasValue && request.CutGroupKeys.ToList().Contains(d.CutGroupKey.Value));

                    uniqueFilters = data?.GroupBy(d => d.CutSubGroupName).Select(d => new SurveyCutFilterFlatOption
                    {
                        Name = d.Key,
                        Keys = d.Where(data => data.CutSubGroupKey.HasValue).Select(data => data.CutSubGroupKey).OfType<int>().Distinct()
                    }).ToList();
                    break;
                case { Industry: true }:
                    uniqueFilters = data?.GroupBy(d => d.IndustrySectorName).Select(d => new SurveyCutFilterFlatOption
                    {
                        Name = d.Key,
                        Keys = d.Where(data => data.IndustrySectorKey.HasValue).Select(data => data.IndustrySectorKey).OfType<int>().Distinct()
                    }).ToList();
                    break;
                default:
                    break;
            }

            return await Task.FromResult(uniqueFilters is not null ? uniqueFilters.Where(qf => !string.IsNullOrEmpty(qf.Name)) : new List<SurveyCutFilterFlatOption>());
        }

        public async Task<SurveyCutsDataListResponse> ListSurveyCuts(SurveyCutsRequest request)
        {
            var jsonFilePath = "Mocks/survey_cuts.json";
            var jsonData = System.IO.File.ReadAllText(jsonFilePath);

            var data = DeserializeJson<IEnumerable<SurveyCutsDataResponse>>(jsonData) ?? new List<SurveyCutsDataResponse>();

            if (request.SurveyPublisherKeys is not null && request.SurveyPublisherKeys.Any())
            {
                data = data?.Where(c => c.SurveyPublisherKey.HasValue && request.SurveyPublisherKeys.ToList().Contains(c.SurveyPublisherKey.Value));
            }
            if (request.SurveyYears is not null && request.SurveyYears.Any())
            {
                data = data?.Where(c => request.SurveyYears.ToList().Contains(c.SurveyYear));
            }
            if (request.SurveyKeys is not null && request.SurveyKeys.Any())
            {
                data = data?.Where(c => c.SurveyKey.HasValue && request.SurveyKeys.ToList().Contains(c.SurveyKey.Value));
            }
            if (request.IndustrySectorKeys is not null && request.IndustrySectorKeys.Any())
            {
                data = data?.Where(c => c.IndustrySectorKey.HasValue && request.IndustrySectorKeys.ToList().Contains(c.IndustrySectorKey.Value));
            }
            if (request.OrganizationTypeKeys is not null && request.OrganizationTypeKeys.Any())
            {
                data = data?.Where(c => c.OrganizationTypeKey.HasValue && request.OrganizationTypeKeys.ToList().Contains(c.OrganizationTypeKey.Value));
            }
            if (request.CutGroupKeys is not null && request.CutGroupKeys.Any())
            {
                data = data?.Where(c => c.CutGroupKey.HasValue && request.CutGroupKeys.ToList().Contains(c.CutGroupKey.Value));
            }
            if (request.CutSubGroupKeys is not null && request.CutSubGroupKeys.Any())
            {
                data = data?.Where(c => c.CutSubGroupKey.HasValue && request.CutSubGroupKeys.ToList().Contains(c.CutSubGroupKey.Value));
            }

            var surveyDetails = data?.Distinct().ToList() ?? new List<SurveyCutsDataResponse>();

            return await Task.FromResult(new SurveyCutsDataListResponse { SurveyCutsData = surveyDetails });
        }

        public async Task<SurveyCutsDataListResponse> ListSurveyCuts()
        {
            return await ListSurveyCuts(new SurveyCutsRequest());
        }

        public async Task<SurveyCutsDataListResponse> ListSurveyCutsDataStandardJobs(SurveyCutsDataRequest request)
        {
            var jsonFilePath = "Mocks/survey_cut_data.json";
            var jsonData = System.IO.File.ReadAllText(jsonFilePath);
            var data = DeserializeJson<IEnumerable<StandardJobResponse>>(jsonData) ?? new List<StandardJobResponse>();


            if (string.IsNullOrEmpty(request.StandardJobSearch))
                return new SurveyCutsDataListResponse();

            data = data.Where(item =>
                         (item.StandardJobCode?.Trim().ToLower().Contains(request.StandardJobSearch.Trim().ToLower()) ?? false) ||
                         (item.StandardJobTitle?.Trim().ToLower().Contains(request.StandardJobSearch.Trim().ToLower()) ?? false) ||
                         (item.StandardJobDescription?.Trim().ToLower().Contains(request.StandardJobSearch.Trim().ToLower()) ?? false))
                .DistinctBy(x => x.StandardJobCode + "." + x.StandardJobTitle + "." + x.StandardJobDescription);

            var result = new SurveyCutsDataListResponse { StandardJobs = data.ToList() };

            return await Task.FromResult(result);
        }

        public async Task<IEnumerable<MarketPercentileSet>> ListPercentiles(SurveyCutsRequest request)
        {
            if (request.StandardJobCodes is null || !request.StandardJobCodes.Any())
                return new List<MarketPercentileSet>();

            var jsonFilePath = "Mocks/percentiles.json";
            var jsonData = System.IO.File.ReadAllText(jsonFilePath);
            var data = DeserializeJson<IEnumerable<MockMarketPercentileSet>>(jsonData) ?? new List<MockMarketPercentileSet>();

            var percentiles = data.Where(d => request.StandardJobCodes.Contains(d.standard_job_code)).SelectMany(d => d.market_value_by_percentile);

            var result = percentiles.Select(p => new MarketPercentileSet
            {
                Percentile = p.Percentile,
                MarketValue = p.MarketValue
            });

            return await Task.FromResult(result.Where(r => r.MarketValue.HasValue) ?? new List<MarketPercentileSet>());
        }

        public async Task<IEnumerable<MarketPercentileSet>> ListAllPercentilesByStandardJobCode(SurveyCutsRequest request)
        {
            return await ListPercentiles(request);
        }

        private static T? DeserializeJson<T>(string jsonData)
        {
            return JsonConvert.DeserializeObject<T>(jsonData);
        }

        public async Task<SurveyCutsDataListResponse> ListSurveyCutsDataPublishers(SurveyCutsDataRequest request)
        {
            var jsonFilePath = "Mocks/survey_cut_data.json";
            var jsonData = System.IO.File.ReadAllText(jsonFilePath);
            var data = DeserializeJson<IEnumerable<PublisherResponse>>(jsonData) ?? new List<PublisherResponse>();

            if (request.StandardJobCodes == null || !request.StandardJobCodes.Any())
                return new SurveyCutsDataListResponse();

            data = data.DistinctBy(x => x.PublisherKey + "." + x.PublisherName);

            var result = new SurveyCutsDataListResponse { Publishers = data.ToList() };
            return await Task.FromResult(result);
        }

        public async Task<SurveyCutsDataListResponse> ListSurveyCutsDataJobs(SurveyCutsDataRequest request)
        {
            var jsonFilePath = "Mocks/survey_cut_data.json";
            var jsonData = System.IO.File.ReadAllText(jsonFilePath);
            var data = DeserializeJson<IEnumerable<MockSurveyJobResponse>>(jsonData) ?? new List<MockSurveyJobResponse>();

            if (request.StandardJobCodes == null || !request.StandardJobCodes.Any() || request.PublisherKey == null)
                return new SurveyCutsDataListResponse();

            if (request.StandardJobCodes is not null && request.StandardJobCodes.Any())
            {
                data = data.Where(d => d.StandardJobCode != null && request.StandardJobCodes.Contains(d.StandardJobCode));
            }

            if (request.PublisherKey is not null)
            {
                data = data.Where(d => d.PublisherKey != null && request.PublisherKey == d.PublisherKey);
            }

            var surveys = data.Select(p => new SurveyJobResponse
            {
                SurveyJobCode = p.SurveyJobCode,
                SurveyJobTitle = p.SurveyJobTitle,
                SurveyJobDescription = p.SurveyJobDescription,
                SurveyYear = p.SurveyYear
            })
                .DistinctBy(x => x.SurveyJobCode + "." + x.SurveyJobTitle + "." + x.SurveyJobDescription);

            var response = new SurveyCutsDataListResponse()
            {
                SurveyJobs = surveys.ToList()
            };

            return await Task.FromResult(response);
        }

        public async Task<SurveyCutsDataListResponse> ListSurveyCutsDataWithPercentiles(SurveyCutsRequest request)
        {
            if (request.StandardJobCodes is null || !request.StandardJobCodes.Any())
                return new SurveyCutsDataListResponse();

            var jsonFilePath = "Mocks/survey_cuts_with_percentiles.json";
            var jsonData = System.IO.File.ReadAllText(jsonFilePath);
            var data = DeserializeJson<IEnumerable<SurveyCutsDataResponse>>(jsonData) ?? new List<SurveyCutsDataResponse>();

            var result = new SurveyCutsDataListResponse
            {
                SurveyCutsData = data.Where(d => !string.IsNullOrEmpty(d.StandardJobCode) &&
                                                 request.StandardJobCodes.Contains(d.StandardJobCode))
                                     .ToList()
            };

            return await Task.FromResult(result);
        }
    }

    public class MockMarketPercentileSet
    {
        public int? industry_sector_key { get; set; } = null;
        public int? organization_type_key { get; set; } = null;
        public int? cut_group_key { get; set; } = null;
        public int? cut_sub_group_key { get; set; } = null;
        public string standard_job_code { get; set; } = string.Empty;
        public List<MarketPercentileSet> market_value_by_percentile { get; set; } = new List<MarketPercentileSet>();
    }

    public class MockSurveyJobResponse
    {
        public int? PublisherKey { get; set; }
        public string? PublisherName { get; set; }
        public string? SurveyJobDescription { get; set; }
        public string? SurveyJobCode { get; set; }
        public string? SurveyJobTitle { get; set; }
        public string? StandardJobCode { get; set; }
        public string? SurveyYear { get; set; }
    }
}
