﻿namespace CN.Incumbent.Models.S3;

public class S3Object
{
    public string Name { get; set; } = null!;
    public MemoryStream InputStream { get; set; } = null!;
}
