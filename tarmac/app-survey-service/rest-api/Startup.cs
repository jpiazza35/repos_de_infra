using CN.Survey.Domain;
using CN.Survey.Domain.Services;
using CN.Survey.Infrastructure;
using CN.Survey.Infrastructure.MockRepositories;
using CN.Survey.Infrastructure.Repositories;
using CN.Survey.RestApi.Transformation;
using CN.Survey.RestApi.Services;
using Cn.User;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.OpenApi.Models;
using Microsoft.IdentityModel.Tokens;
using Microsoft.Identity.Web;
using Microsoft.OpenApi.Models;

namespace CN.Survey.RestApi;

public class Startup
{
    public Startup(IWebHostEnvironment environment, IConfiguration configuration)
    {
        Configuration = configuration;
        Environment = environment;
    }

    public IConfiguration Configuration { get; }
    public IWebHostEnvironment Environment { get; set; }

    // This method gets called by the runtime. Use this method to add services to the container.
    public void ConfigureServices(IServiceCollection services)
    {
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

        services.AddScoped<IDBContext, BenchmarkDBContext>();

        // Add Mock Repositories when the environment is dev
        if (Environment.IsDevelopment())
        {
            services.AddScoped<IBenchmarkDataTypeRepository, MockBenchmarkDataTypeRepository>();
            services.AddScoped<ISourceGroupRepository, MockSourceGroupRepository>();
            services.AddScoped<ISurveyCutsRepository, MockSurveyCutsRepository>(); 
        }
        else
        {
            services.AddScoped<IBenchmarkDataTypeRepository, BenchmarkDataTypeRepository>();
            services.AddScoped<ISourceGroupRepository, SourceGroupRepository>();
            services.AddScoped<ISurveyCutsRepository, SurveyCutsRepository>();
        }

        services.AddScoped<IMarketSegmentService, MarketSegmentService>();
        services.AddScoped<ISurveyCutsService, SurveyCutsService>();

        services.AddScoped<IClaimsTransformation, AddRolesClaimsTransformation>();

        services.AddGrpcClient<User.UserClient>(o =>
        {
            o.Address = new Uri(Configuration["UserServerUrl"] ?? throw new ArgumentNullException("UserServerUrl"));
        });

        // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
        services.AddControllers();
        services.AddEndpointsApiExplorer();
        services.AddSwaggerGen();

        services.AddSwaggerGen(c =>
        {
            c.SwaggerDoc("v1", new OpenApiInfo { Title = "SurveyAPI", Version = "v1" });
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
