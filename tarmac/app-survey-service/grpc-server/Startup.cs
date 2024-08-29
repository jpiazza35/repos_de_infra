using AutoMapper;
using CN.Survey.Domain;
using CN.Survey.GrpcServer.Services;
using CN.Survey.Infrastructure;
using CN.Survey.Infrastructure.MockRepositories;
using CN.Survey.Infrastructure.Repositories;

namespace CN.Survey.GrpcServer
{
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
            IMapper mapper = MappingConfig.RegisterMaps().CreateMapper();
            services.AddSingleton(mapper);
            services.AddScoped<IDBContext, BenchmarkDBContext>();

            // Add Mock Repositories when the environment is dev
            if (Environment.IsDevelopment())
            {
                services.AddScoped<IBenchmarkDataTypeRepository, MockBenchmarkDataTypeRepository>();
                services.AddScoped<ISurveyCutsRepository, MockSurveyCutsRepository>();
            }
            else
            {
                services.AddScoped<IBenchmarkDataTypeRepository, BenchmarkDataTypeRepository>();
                services.AddScoped<ISurveyCutsRepository, SurveyCutsRepository>();
            }

            services.AddGrpc();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(WebApplication app, IWebHostEnvironment env)
        {
            app.MapGrpcService<SurveyGrpcService>();
            app.Run();
        }
    }
}
