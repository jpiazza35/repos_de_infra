using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CN.Incumbent.Domain.Enum
{
    public enum FileStatus
    {
        Started = 1,
        Uploaded = 2,
        Validating = 3,
        Invalid = 4,
        Valid = 5,
        ValidWithWarnings = 6,
        ValidOudated = 7,
        ValidWithWarningsOutdated = 8
    }
}
