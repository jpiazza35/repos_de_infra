using System.ComponentModel.DataAnnotations;

namespace CN.Project.Domain;

    public class Organization
    {
        [Key]
        public int Id { get; set; }
        public string? Name { get; set; }
    }

