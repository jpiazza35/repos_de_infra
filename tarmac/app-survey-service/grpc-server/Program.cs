using CN.Survey.GrpcServer;

var builder = WebApplication.CreateBuilder(args);
builder.Logging.ClearProviders();
builder.Logging.AddConsole();
builder.Services.AddHealthChecks();

// Use only the configuration providers we want
builder.Configuration.Sources.Clear();
builder.Configuration.AddJsonFile("appsettings.json");
if (builder.Environment.IsDevelopment()) builder.Configuration.AddJsonFile("appsettings.Development.json");
builder.Configuration.AddEnvironmentVariables(prefix: "CN_");
builder.Configuration.AddCommandLine(args);

var startup = new Startup(builder.Environment, builder.Configuration);
startup.ConfigureServices(builder.Services);

var app = builder.Build();
startup.Configure(app, builder.Environment);