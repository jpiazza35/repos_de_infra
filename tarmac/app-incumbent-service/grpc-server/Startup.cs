using AutoMapper;
using CN.Incumbent.Domain;
using CN.Incumbent.Infrastructure.Repositories;
using CN.Incumbent.Infrastructure;
using CN.Organization.GrpcServer;
using System.Globalization;

namespace CN.Incumbent.GrpcServer
{
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

            IMapper mapper = MappingConfig.RegisterMaps().CreateMapper();
            services.AddSingleton(mapper);
            services.AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies());
            services.AddScoped<IDBContext, IncumbentDBContext>();
            services.AddScoped<IFileRepository, FileRepository>();
            services.AddScoped<ISourceDataRepository, SourceDataRepository>();

            services.AddGrpc();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(WebApplication app, IWebHostEnvironment env)
        {
            app.MapGrpcService<IncumbentService>();
            app.Run();
        }
    }
}
