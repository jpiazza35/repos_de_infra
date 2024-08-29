Gem::Specification.new do |spec|
    spec.name          = "buf_gem"
    spec.version       = "0.1.0"
    spec.authors       = ["data_team"]
    spec.summary       = "app-shared-protobuffs - Ruby files"
    spec.description   = "app-shared-protobuffs - Ruby files"
    spec.homepage      = "https://github.com/clinician-nexus/app-shared-protobuffs"
  
    # Here you can list the .rb files you want to add to the gem.
    spec.files         = Dir[
      "/home/runner/work/app-shared-protobuffs/app-shared-protobuffs/ruby/src/cn/anomalyprofiling/v1/*.rb",
      "/home/runner/work/app-shared-protobuffs/app-shared-protobuffs/ruby/src/cn/benchmark/v1/*.rb",
      "/home/runner/work/app-shared-protobuffs/app-shared-protobuffs/ruby/src/cn/dataexchange/files/v1/*.rb",
      "/home/runner/work/app-shared-protobuffs/app-shared-protobuffs/ruby/src/cn/datagovernance/v1/*.rb",
      "/home/runner/work/app-shared-protobuffs/app-shared-protobuffs/ruby/src/cn/dataworkbench/v1/*.rb",
      "/home/runner/work/app-shared-protobuffs/app-shared-protobuffs/ruby/src/cn/incumbsent/v1/*.rb",
      "/home/runner/work/app-shared-protobuffs/app-shared-protobuffs/ruby/src/cn/organization/v1/*.rb",
      "/home/runner/work/app-shared-protobuffs/app-shared-protobuffs/ruby/src/cn/simpleintegration/v1/*.rb",
      "/home/runner/work/app-shared-protobuffs/app-shared-protobuffs/ruby/src/cn/statustracking/v1/*.rb",
      "/home/runner/work/app-shared-protobuffs/app-shared-protobuffs/ruby/src/cn/survey/app/v1/*.rb",
      "/home/runner/work/app-shared-protobuffs/app-shared-protobuffs/ruby/src/cn/survey/physician/v1/*.rb",
      "/home/runner/work/app-shared-protobuffs/app-shared-protobuffs/ruby/src/cn/survey/v1/*.rb",
      "/home/runner/work/app-shared-protobuffs/app-shared-protobuffs/ruby/src/google/type/*.rb",
    
  
    ]
    # Also, you can dependencies from other gems.
    # spec.add_runtime_dependency "gem_name", ">= 1.0"
  
    # Other optional configurations, documentation files, etc.
  
  end