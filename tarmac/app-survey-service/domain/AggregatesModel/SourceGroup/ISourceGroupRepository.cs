namespace CN.Survey.Domain;

public interface ISourceGroupRepository
{
    Task<List<SourceGroup>?> GetSourceGroups();
}