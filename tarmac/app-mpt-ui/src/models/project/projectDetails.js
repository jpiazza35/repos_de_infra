export class ProjectDetails {
  constructor(fields) {
    if (fields) {
      this.id = fields.id || 0;
      this.name = fields.name;
      this.organizationID = fields.organizationID;
      this.organizationName = fields.organizationName || "";
      this.version = fields.version || 1;
      this.versionDate = fields.versionDate ? new Date(fields.versionDate) : new Date();
      this.versionLabel = fields.versionLabel || this.version.toString();
      this.workforceProjectType = parseInt(fields.workforceProjectType);
      this.aggregationMethodologyKey = fields.aggregationMethodologyKey || 1;
      this.aggregationMethodologyName = fields.aggregationMethodologyName || "";
      this.projectStatus = parseInt(fields.projectStatus) || 1;
      this.sourceDataInfo = fields.sourceDataInfo ? new SourceDataInfo(fields.sourceDataInfo) : new SourceDataInfo({});
      this.benchmarkDataTypes = fields.benchmarkDataTypes ? fields.benchmarkDataTypes.map(type => new BenchmarkDataTypeInfo(type)) : [];
    }
  }
}

export class SourceDataInfo {
  constructor(fields) {
    const sourceDataType = fields.sourceDataType || ["Incumbent", "Job"].includes(fields.sourceData) ? 1 : 0;
    if (fields) {
      this.sourceDataType = sourceDataType;
      this.sourceData = fields.sourceData || "";
      this.file = fields.file;
      this.effectiveDate = fields.effectiveDate ? new Date(fields.effectiveDate) : "";

      this.fileLogKey = fields.key || fields.fileLogKey;
    }
  }
}

export class BenchmarkDataTypeInfo {
  constructor(fields) {
    if (fields) {
      this.id = fields.id;
      this.benchmarkDataTypeKey = fields.benchmarkDataTypeKey;
      this.name = fields.name;
      this.agingFactor = fields.agingFactor;
      this.defaultDataType = fields.defaultDataType;
      this.orderDataType = fields.orderDataType;
      this.overrideAgingFactor = fields.overrideAgingFactor || "";
      this.overrideNote = fields.overrideNote || "";
      this.longAlias = fields.longAlias;
      this.shortAlias = fields.shortAlias;
      this.format = fields.format;
      this.decimals = fields.decimals;
      this.checked = fields.checked ?? false;
    }
  }
}

export const ProjectStatus = {
  DRAFT: 1,
  FINAL: 2,
  DELETED: 3,
};

export const FileStatus = {
  Started: 1,
  Uploaded: 2,
  Validating: 3,
  Invalid: 4,
  Valid: 5,
  ValidWithWarnings: 6,
  ValidOudated: 7,
  ValidWithWarningsOutdated: 8,
};
