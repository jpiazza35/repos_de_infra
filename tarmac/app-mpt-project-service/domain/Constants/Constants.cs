using CN.Project.Domain.Models.Dto;

namespace CN.Project.Domain.Constants;

public class Constants
{
    public const string SYSTEM_USER = "system";
    public const string NATIONAL_GROUP_NAME = "National";
    public const string ANNUAL_BASE_BENCHMARK = "Annualized Base Salary";
    public const string HOURLY_BASE_BENCHMARK = "Base Pay Hourly Rate";

    public static readonly List<SortableColumnDto> MPS_SORTABLE_COLUMNS = new List<SortableColumnDto>
    {
        new SortableColumnDto { Id = 1, Name = "Market pricing sheet ID", JobTitleName = "MarketPricingSheetId", PdfName = "Id" },
        new SortableColumnDto { Id = 2, Name = "Client Job code", JobTitleName = "JobCode", PdfName = "JobCode" },
        new SortableColumnDto { Id = 3, Name = "Client Job title", JobTitleName = "JobTitle", PdfName = "JobTitle" },
        new SortableColumnDto { Id = 4, Name = "Client Job group", JobTitleName = "", PdfName = "JobGroup"},
        new SortableColumnDto { Id = 5, Name = "Market segment name", JobTitleName = "MarketSegmentName", PdfName = "MarketSegmentName" },
        new SortableColumnDto { Id = 6, Name = "Organization name", JobTitleName = "", PdfName = "CesOrgId" },
        
        //This field doesn't have any mapping on the JobTitle and PDF
        new SortableColumnDto { Id = 7, Name = "Job level", JobTitleName = "", PdfName = ""},
    };
}