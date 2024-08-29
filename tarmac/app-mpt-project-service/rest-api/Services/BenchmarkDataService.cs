using CN.Project.Domain.Models.Dto;
using CN.Project.Domain.Services;
using CN.Project.Infrastructure.Repositories;

namespace CN.Project.RestApi.Services
{
    public class BenchmarkDataService : IBenchmarkDataService
    {
        private readonly IBenchmarkDataRepository _benchmarkDataRepository;

        public BenchmarkDataService(IBenchmarkDataRepository benchmarkDataRepository)
        {
            _benchmarkDataRepository = benchmarkDataRepository;
        }

        public async Task<List<BenchmarkDataTypeDto>> GetBenchmarkDataTypes(int sourceGroupKey)
        {
            var surveyBenchmarksTask = _benchmarkDataRepository.GetBenchmarkDataTypes(sourceGroupKey);
            var mptBenchmarksTask = _benchmarkDataRepository.ListBenchmarksFromReferenceTable();

            await Task.WhenAll(surveyBenchmarksTask, mptBenchmarksTask);

            var surveyBenchmarks = await surveyBenchmarksTask;
            var mptBenchmarks = await mptBenchmarksTask;

            if (!mptBenchmarks.Any())
                return surveyBenchmarks;

            foreach (var surveyBenchmark in surveyBenchmarks)
            {
                var benchmarkMatch = mptBenchmarks.FirstOrDefault(b => b.Name == surveyBenchmark.Name);

                if (benchmarkMatch is not null)
                {
                    surveyBenchmark.LongAlias = benchmarkMatch.LongAlias;
                    surveyBenchmark.ShortAlias = benchmarkMatch.ShortAlias;
                    surveyBenchmark.OrderDataType = benchmarkMatch.OrderDataType;
                    surveyBenchmark.Format = benchmarkMatch.Format;
                    surveyBenchmark.Decimals = benchmarkMatch.Decimals;
                }
            }

            return surveyBenchmarks.Where(s => s.OrderDataType.HasValue).OrderBy(s => s.OrderDataType).ToList();
        }
    }
}