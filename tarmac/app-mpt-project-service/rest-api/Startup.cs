using App_MPT_Project_API.Transformation;
using AutoMapper;
using CN.Project.Domain.Services;
using CN.Project.Infrastructure;
using CN.Project.Infrastructure.Repository;
using CN.Project.RestApi.Services;
using Cn.Organization;
using Cn.Survey;
using Cn.User;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Identity.Web;
using Microsoft.OpenApi.Models;
using Cn.Incumbent;
using CN.Project.Infrastructure.Repositories;
using CN.Project.Infrastructure.Repositories.MarketSegment;
using System.Globalization;
using Microsoft.IdentityModel.Tokens;

namespace CN.Project.RestApi;

public class Startup
{
    public Startup(IConfiguration configuration)
    {
        Configuration = configuration;
    }

    public IConfiguration Configuration { get; }

    // This method gets called by the runtime. Use this method to add services to the container.
    public void ConfigureServices(IServiceCollection services)
    {
        // Adding the culture for the whole application
        CultureInfo.DefaultThreadCurrentCulture = new CultureInfo("en-US");

        services.AddCors(p => p.AddPolicy("corsapp", builder =>
        {
            builder.WithOrigins("*").AllowAnyMethod().AllowAnyHeader();
        }));

        if (Configuration.GetValue<bool?>("isOktaAuth") == true)
        {
            services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
            .AddJwtBearer(options =>
            {
                options.Authority = $"https://{Configuration["Auth0:Domain"]}/";
                options.Audience = Configuration["Auth0:Audience"];
                options.TokenValidationParameters.NameClaimType = "name";
            });
        }
        else
        {
            // Adds Microsoft Identity platform (Azure AD B2C) support to protect this Api
            services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
                    .AddMicrosoftIdentityWebApi(options =>
                    {
                        Configuration.Bind("AzureAdB2C", options);
                        options.TokenValidationParameters.NameClaimType = "name";
                    },
            options => { Configuration.Bind("AzureAdB2C", options); });
            // End of the Microsoft Identity platform block  
        }

        IMapper mapper = MappingConfig.RegisterMaps().CreateMapper();
        services.AddSingleton(mapper);
        services.AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies());
        services.AddScoped<IDBContext, ProjectDBContext>();

        #region Add Repositories
        services.AddScoped<IProjectRepository, ProjectRepository>();
        services.AddScoped<IProjectDetailsRepository, ProjectDetailsRepository>();
        services.AddScoped<IFileRepository, FileRepository>();
        services.AddScoped<IMarketSegmentRepository, MarketSegmentRepository>();
        services.AddScoped<IMarketSegmentMappingRepository, MarketSegmentMappingRepository>();
        services.AddScoped<IJobMatchingRepository, JobMatchingRepository>();
        services.AddScoped<ICombinedAveragesRepository, CombinedAveragesRepository>();
        services.AddScoped<IMarketPricingSheetRepository, MarketPricingSheetRepository>();
        services.AddScoped<IJobSummaryTableRepository, JobSummaryTableRepository>();
        services.AddScoped<IMarketPricingSheetFileRepository, MarketPricingSheetFileRepository>();
        services.AddScoped<IBenchmarkDataRepository, BenchmarkDataRepository>();
        #endregion

        #region Add Services
        services.AddScoped<IProjectDetailsService, ProjectDetailsService>();
        services.AddScoped<IMarketSegmentService, MarketSegmentService>();
        services.AddScoped<IMarketSegmentMappingService, MarketSegmentMappingService>();
        services.AddScoped<IJobMatchingService, JobMatchingService>();
        services.AddScoped<IMarketPricingSheetService, MarketPricingSheetService>();
        services.AddScoped<IJobSummaryTableService, JobSummaryTableService>();
        services.AddScoped<IBenchmarkDataService, BenchmarkDataService>();
        services.AddScoped<IGraphService, GraphService>();
        #endregion

        services.AddScoped<IClaimsTransformation, AddRolesClaimsTransformation>();

        services.AddGrpcClient<Organization.OrganizationClient>(o =>
        {
            o.Address = new Uri(Configuration["OrganizationServerUrl"] ?? throw new ArgumentNullException("OrganizationServerUrl"));
        });
        services.AddGrpcClient<User.UserClient>(o =>
        {
            o.Address = new Uri(Configuration["UserServerUrl"] ?? throw new ArgumentNullException("UserServerUrl"));
        });
        services.AddGrpcClient<Survey.SurveyClient>(o =>
        {
            o.Address = new Uri(Configuration["SurveyServerUrl"] ?? throw new ArgumentNullException("SurveyServerUrl"));
        });
        services.AddGrpcClient<Incumbent.IncumbentClient>(o =>
        {
            o.Address = new Uri(Configuration["IncumbentServerUrl"] ?? throw new ArgumentNullException("IncumbentServerUrl"));
        });

        // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle

        services.AddControllers();
        services.AddEndpointsApiExplorer();
        services.AddSwaggerGen();

        services.AddSwaggerGen(c =>
        {
            c.SwaggerDoc("v1", new OpenApiInfo { Title = "ProjectAPI", Version = "v1" });
            c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
            {
                Description = @"Enter 'Bearer' [space] and your token",
                Name = "Authorization",
                In = ParameterLocation.Header,
                Type = SecuritySchemeType.ApiKey,
                Scheme = "Bearer"
            });

            c.AddSecurityRequirement(new OpenApiSecurityRequirement {
                {
                    new OpenApiSecurityScheme
                    {
                        Reference = new OpenApiReference
                        {
                            Type=ReferenceType.SecurityScheme,
                            Id="Bearer"
                        },
                        Scheme="oauth2",
                        Name="Bearer",
                        In=ParameterLocation.Header
                    },
                    new List<string>()
                }
            });
        });
    }

    // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
    public void Configure(WebApplication app, IWebHostEnvironment env)
    {
        // Configure the HTTP request pipeline.
        if (Configuration.GetValue<string?>("Swagger:isEnabled") == "true")
        {
            Console.WriteLine("*** Swagger is enabled ***");
            app.UseSwagger();
            app.UseSwaggerUI();
            app.UseCors("corsapp");
        }

        app.UseAuthentication();

        app.UseAuthorization();

        app.MapControllers();

        app.MapHealthChecks("/health");

        app.Run();
    }
}
