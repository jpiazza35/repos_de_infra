using CN.Project.Domain.Constants;
using CN.Project.Domain.Dto;
using CN.Project.Domain.Models;
using CN.Project.Domain.Models.Dto;
using CN.Project.Domain.Models.Dto.MarketSegment;
using CN.Project.Domain.Services;
using CN.Project.Infrastructure.Repositories.MarketSegment;
using CN.Project.Infrastructure.Repository;

namespace CN.Project.RestApi.Services
{
    public class MarketSegmentService : IMarketSegmentService
    {
        private readonly IMarketSegmentRepository _marketSegmentRepository;
        private readonly ICombinedAveragesRepository _combinedAveragesRepository;

        public MarketSegmentService(IMarketSegmentRepository marketSegmentRepository, ICombinedAveragesRepository combinedAveragesRepository)
        {
            _marketSegmentRepository = marketSegmentRepository;
            _combinedAveragesRepository = combinedAveragesRepository;
        }

        public async Task<MarketSegmentDto> SaveMarketSegment(MarketSegmentDto marketSegment, string? userObjectId)
        {
            var user = GetUser(userObjectId);

            var marketSegmentId = await _marketSegmentRepository.SaveMarketSegment(marketSegment, user);

            return await GetMarketSegment(marketSegmentId);
        }

        public async Task<MarketSegmentDto> SaveAsMarketSegment(MarketSegmentDto marketSegment, string? userObjectId)
        {
            var user = GetUser(userObjectId);

            var existingMarketSegmentTask = GetMarketSegment(marketSegment.Id);
            var existingCombinedAveragesTask = GetCombinedAverages(marketSegment.Id);

            await Task.WhenAll(existingMarketSegmentTask, existingCombinedAveragesTask);

            var existingMarketSegment = await existingMarketSegmentTask;
            var existingCombinedAverages = await existingCombinedAveragesTask;

            if (existingMarketSegment is null || existingMarketSegment.Id == 0)
                return new MarketSegmentDto();

            existingMarketSegment.ProjectVersionId = marketSegment.ProjectVersionId;
            existingMarketSegment.Name = marketSegment.Name;
            existingMarketSegment.Status = Domain.Enum.MarketSegmentStatus.Draft;

            var newMarketSegmentId = await _marketSegmentRepository.SaveMarketSegment(existingMarketSegment, user);

            if (existingMarketSegment.Blends is not null)
            {
                var blendsTaskList = new List<Task>();

                foreach (var blend in existingMarketSegment.Blends)
                {
                    blend.MarketSegmentCutKey = 0;

                    blendsTaskList.Add(SaveMarketSegmentBlend(newMarketSegmentId, blend, userObjectId));
                }

                await Task.WhenAll(blendsTaskList);
            }

            if (existingCombinedAverages is not null)
            {
                var combinedAveragesTaskList = new List<Task>();

                foreach (var combinedAverage in existingCombinedAverages)
                {
                    combinedAverage.MarketSegmentId = newMarketSegmentId;

                    combinedAveragesTaskList.Add(InsertCombinedAverage(combinedAverage, userObjectId));
                }

                await Task.WhenAll(combinedAveragesTaskList);
            }

            return await GetMarketSegment(newMarketSegmentId);
        }

        public async Task<MarketSegmentDto?> EditMarketSegment(MarketSegmentDto marketSegment, string? userObjectId)
        {
            var marketSegmentId = marketSegment.Id;
            var user = GetUser(userObjectId);

            var existingMarketSegment = await GetMarketSegment(marketSegmentId);

            await _marketSegmentRepository.EditMarketSegment(existingMarketSegment, marketSegment, user);

            return await GetMarketSegment(marketSegmentId);
        }

        public async Task<List<MarketSegmentDto>> GetMarketSegments(int projectVersionId)
        {
            var marketSegments = await _marketSegmentRepository.GetMarketSegmentsWithCuts(projectVersionId);

            if (marketSegments is not null && marketSegments.Any())
            {
                await FillMarketSegmentCuts(marketSegments);
            }

            return marketSegments ?? new List<MarketSegmentDto>();
        }

        public async Task<NameAmount?> CheckCurrentEriNameOnUSe(int marketSegmentId)
        {
            return await _marketSegmentRepository.CheckCurrentEriNameOnUSe(marketSegmentId);
        }

        public async Task<MarketSegmentDto> SaveMarketSegmentEri(MarketSegmentDto marketSegment, string? userObjectId)
        {
            var existingMarketSegment = await GetMarketSegment(marketSegment.Id);

            var nationalCuts = existingMarketSegment.Cuts?.Where(c => !string.IsNullOrEmpty(c.CutGroupName) && c.CutGroupName.Equals(Constants.NATIONAL_GROUP_NAME));

            if (nationalCuts is null || !nationalCuts.Any())
                return new MarketSegmentDto();

            var user = GetUser(userObjectId);

            await _marketSegmentRepository.EditMarketSegmentEri(marketSegment, user);

            if (existingMarketSegment is not null)
            {
                await _combinedAveragesRepository.UpdateCombinedAverageCutName(marketSegment.Id, existingMarketSegment.EriCutName, marketSegment.EriCutName, user);
            }

            return await GetMarketSegment(marketSegment.Id);
        }

        public async Task<IEnumerable<MarketSegmentBlendDto>?> SaveMarketSegmentBlend(int marketSegmentId, MarketSegmentBlendDto blend, string? userObjectId)
        {
            var user = GetUser(userObjectId);

            if (blend.MarketSegmentCutKey > 0)
            {
                var existingChildren = await _marketSegmentRepository.GetMarketSegmentBlendChildren(new List<int> { blend.MarketSegmentCutKey });

                await _marketSegmentRepository.EditMarketSegmentBlend(blend, user, existingChildren);
            }
            else
                await _marketSegmentRepository.SaveMarketSegmentBlend(marketSegmentId, blend, user);

            var updatedMarketSegment = await GetMarketSegment(marketSegmentId);

            return updatedMarketSegment.Blends;
        }

        public async Task<MarketSegmentDto?> EditMarketSegmentCutDetails(int marketSegmentId, IEnumerable<MarketSegmentCutDetailDto> cutDetails, string? userObjectId)
        {
            var user = GetUser(userObjectId);

            var existingMarketSegment = await GetMarketSegment(marketSegmentId);

            if (existingMarketSegment.Cuts is not null)
            {
                //Blends should not be included 
                foreach (var cut in existingMarketSegment.Cuts.Where(cut => !cut.BlendFlag))
                {
                    //Cuts are groups of Industry, Organization, Cut Group and Cut Subgroup
                    var newDetails = cutDetails.Where(cd => cd.IndustrySectorName == cut.IndustrySectorName
                                                            && cd.OrganizationTypeName == cut.OrganizationTypeName
                                                            && cd.CutGroupName == cut.CutGroupName
                                                            && cd.CutSubGroupName == cut.CutSubGroupName);

                    if (cut.CutDetails is null || !cut.CutDetails.Any())
                        cut.CutDetails = new List<MarketSegmentCutDetailDto> { new MarketSegmentCutDetailDto { MarketSegmentCutKey = cut.MarketSegmentCutKey } };

                    await _marketSegmentRepository.EditMarketSegmentCutDetails(cut.CutDetails, newDetails, user);
                }
            }

            // Send the new updated Market Segment
            return await GetMarketSegment(marketSegmentId);
        }

        public async Task<ResponseDto> DeleteMarketSegment(int marketSegmentId, string? userObjectId)
        {
            var jobCodes = await _marketSegmentRepository.ListJobCodesMapped(marketSegmentId);

            if (jobCodes.Any())
            {
                var errorMessage = $"The respective Job Codes are mapped for this Market Segment: {string.Join(", ", jobCodes)}";
                return new ResponseDto { IsSuccess = false, ErrorMessages = new List<string> { errorMessage } };
            }

            await _marketSegmentRepository.DeleteMarketSegment(marketSegmentId, userObjectId);

            return new ResponseDto { IsSuccess = true };
        }

        private string GetUser(string? userObjectId)
        {
            return string.IsNullOrEmpty(userObjectId) ? Constants.SYSTEM_USER : userObjectId;
        }

        private async Task<MarketSegmentDto> GetMarketSegment(int marketSegmentId)
        {
            var marketSegment = await _marketSegmentRepository.GetMarketSegment(marketSegmentId);

            if (marketSegment is null || marketSegment.Id == 0)
                return new MarketSegmentDto();

            await FillMarketSegmentCuts(new List<MarketSegmentDto> { marketSegment });

            return marketSegment;
        }

        private async Task FillMarketSegmentCuts(List<MarketSegmentDto> marketSegments)
        {
            var marketSegmentCuts = marketSegments.Where(x => x.Cuts is not null).SelectMany(x => x.Cuts);

            if (marketSegmentCuts is not null && marketSegmentCuts.Any())
            {
                var publisherKeys = new List<int>();
                var surveyKeys = new List<int>();
                var industrySectorKeys = new List<int>();
                var organizationTypeKeys = new List<int>();
                var cutGroupKeys = new List<int>();
                var cutSubGroupKeys = new List<int>();

                foreach (var cut in marketSegmentCuts)
                {
                    var cutDetails = cut?.CutDetails ?? new List<MarketSegmentCutDetailDto>();

                    publisherKeys.AddRange(cutDetails.Select(cd => cd.PublisherKey).OfType<int>());
                    surveyKeys.AddRange(cutDetails.Select(cd => cd.SurveyKey).OfType<int>());
                    industrySectorKeys.AddRange(cutDetails.Select(cd => cd.IndustrySectorKey).OfType<int>());
                    organizationTypeKeys.AddRange(cutDetails.Select(cd => cd.OrganizationTypeKey).OfType<int>());
                    cutGroupKeys.AddRange(cutDetails.Select(cd => cd.CutGroupKey).OfType<int>());
                    cutSubGroupKeys.AddRange(cutDetails.Select(cd => cd.CutSubGroupKey).OfType<int>());
                }

                // We need to fill Naming information coming from the Survey Domain
                SurveyCutDto surveyCut = await GetSurveyCutInformation(publisherKeys.Distinct().ToList(),
                    surveyKeys.Distinct().ToList(),
                    industrySectorKeys.Distinct().ToList(),
                    organizationTypeKeys.Distinct().ToList(),
                    cutGroupKeys.Distinct().ToList(),
                    cutSubGroupKeys.Distinct().ToList());

                FillMarketSegmentCutsWithSurveyInformation(marketSegments, surveyCut);
            }
        }

        private async Task<SurveyCutDto> GetSurveyCutInformation(List<int> publisherKeys, List<int> surveyKeys, List<int> industrySectorKeys, List<int> organizationTypeKeys, List<int> cutGroupKeys, List<int> cutSubGroupKeys)
        {
            var surveyCutRequest = new SurveyCutRequestDto
            {
                PublisherKeys = publisherKeys.Distinct(),
                SurveyKeys = surveyKeys.Distinct(),
                IndustrySectorKeys = industrySectorKeys.Distinct(),
                OrganizationTypeKeys = organizationTypeKeys.Distinct(),
                CutGroupKeys = cutGroupKeys.Distinct(),
                CutSubGroupKeys = cutSubGroupKeys.Distinct(),
            };

            return await _marketSegmentRepository.GetSurveyCut(surveyCutRequest);
        }

        private void FillMarketSegmentCutsWithSurveyInformation(IEnumerable<MarketSegmentDto> marketSegments, SurveyCutDto surveyCut)
        {
            //Parallel loops to enhance performance, in order to debug, replace it for a regular foreach loop
            Parallel.ForEach(marketSegments, marketSegment =>
            {
                if (marketSegment.Cuts is not null)
                {
                    Parallel.ForEach(marketSegment.Cuts, cut =>
                    {
                        cut.IndustrySectorName = surveyCut.Industries?.FirstOrDefault(i => cut.IndustrySectorKey.HasValue && i.Keys?.Contains(cut.IndustrySectorKey.Value) == true)?.Name;
                        cut.OrganizationTypeName = surveyCut.Organizations?.FirstOrDefault(i => cut.OrganizationTypeKey.HasValue && i.Keys?.Contains(cut.OrganizationTypeKey.Value) == true)?.Name;
                        cut.CutGroupName = surveyCut.CutGroups?.FirstOrDefault(i => cut.CutGroupKey.HasValue && i.Keys?.Contains(cut.CutGroupKey.Value) == true)?.Name;
                        cut.CutSubGroupName = surveyCut.CutSubGroups?.FirstOrDefault(i => cut.CutSubGroupKey.HasValue && i.Keys?.Contains(cut.CutSubGroupKey.Value) == true)?.Name;

                        if (cut.CutDetails is not null)
                        {
                            Parallel.ForEach(cut.CutDetails, cutDetail =>
                            {
                                cutDetail.PublisherName = surveyCut.Publishers?.FirstOrDefault(i => cutDetail.PublisherKey.HasValue && i.Keys?.Contains(cutDetail.PublisherKey.Value) == true)?.Name;
                                cutDetail.SurveyName = surveyCut.Surveys?.FirstOrDefault(i => cutDetail.SurveyKey.HasValue && i.Keys?.Contains(cutDetail.SurveyKey.Value) == true)?.Name;
                                cutDetail.IndustrySectorName = surveyCut.Industries?.FirstOrDefault(i => cutDetail.IndustrySectorKey.HasValue && i.Keys?.Contains(cutDetail.IndustrySectorKey.Value) == true)?.Name;
                                cutDetail.OrganizationTypeName = surveyCut.Organizations?.FirstOrDefault(i => cutDetail.OrganizationTypeKey.HasValue && i.Keys?.Contains(cutDetail.OrganizationTypeKey.Value) == true)?.Name;
                                cutDetail.CutGroupName = surveyCut.CutGroups?.FirstOrDefault(i => cutDetail.CutGroupKey.HasValue && i.Keys?.Contains(cutDetail.CutGroupKey.Value) == true)?.Name;
                                cutDetail.CutSubGroupName = surveyCut.CutSubGroups?.FirstOrDefault(i => cutDetail.CutSubGroupKey.HasValue && i.Keys?.Contains(cutDetail.CutSubGroupKey.Value) == true)?.Name;
                                cutDetail.CutName = surveyCut.Cuts?.FirstOrDefault(i => cutDetail.CutKey.HasValue && i.Keys?.Contains(cutDetail.CutKey.Value) == true)?.Name;
                                cutDetail.Year = surveyCut.SurveyYears?.FirstOrDefault(i => cutDetail.SurveyKey.HasValue && i.SurveyKey == cutDetail.SurveyKey.Value)?.SurveyYear;
                            });
                        }
                    });
                }

                if (marketSegment.Blends is not null)
                {
                    Parallel.ForEach(marketSegment.Blends, blend =>
                    {
                        if (blend.Cuts is not null)
                        {
                            Parallel.ForEach(blend.Cuts, cut =>
                            {
                                cut.IndustrySectorName = surveyCut.Industries?.FirstOrDefault(i => cut.IndustrySectorKey.HasValue && i.Keys?.Contains(cut.IndustrySectorKey.Value) == true)?.Name;
                                cut.OrganizationTypeName = surveyCut.Organizations?.FirstOrDefault(i => cut.OrganizationTypeKey.HasValue && i.Keys?.Contains(cut.OrganizationTypeKey.Value) == true)?.Name;
                                cut.CutGroupName = surveyCut.CutGroups?.FirstOrDefault(i => cut.CutGroupKey.HasValue && i.Keys?.Contains(cut.CutGroupKey.Value) == true)?.Name;
                                cut.CutSubGroupName = surveyCut.CutSubGroups?.FirstOrDefault(i => cut.CutSubGroupKey.HasValue && i.Keys?.Contains(cut.CutSubGroupKey.Value) == true)?.Name;
                            });
                        }
                    });
                }
            });
        }

        #region Combined Averages

        public async Task<List<CombinedAveragesDto>> GetCombinedAverages(int marketSegmentId)
        {
            var combinedAverages = await _combinedAveragesRepository.GetCombinedAveragesByMarketSegmentId(marketSegmentId);
            return combinedAverages is not null ? combinedAverages : new List<CombinedAveragesDto>();
        }

        public async Task<List<string>> GetCombinedAveragesCutNames(int marketSegmentId)
        {
            var cutNames = await _combinedAveragesRepository.GetCombinedAveragesCutNames(marketSegmentId);
            return cutNames is not null ? cutNames : new List<string>();
        }

        public async Task InsertCombinedAverage(CombinedAveragesDto combinedAverages, string? userObjectId)
        {
            await _combinedAveragesRepository.InsertCombinedAverage(combinedAverages, userObjectId);
        }

        public async Task InsertAndUpdateAndRemoveCombinedAverages(int marketSegmentId, List<CombinedAveragesDto> combinedAverages, string? userObjectId)
        {
            await _combinedAveragesRepository.InsertAndUpdateAndRemoveCombinedAverages(marketSegmentId, combinedAverages, userObjectId);
        }

        public async Task UpdateCombinedAverages(CombinedAveragesDto combinedAverages, string? userObjectId)
        {
            await _combinedAveragesRepository.UpdateCombinedAverages(combinedAverages, userObjectId);
        }

        #endregion
    }
}