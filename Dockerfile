FROM mcr.microsoft.com/dotnet/sdk:5.0 as base

WORKDIR /opt/blogifier
ENV PATH="$PATH:/root/.dotnet/tools"

RUN apt-get update && apt-get install -y apt-transport-https

RUN dpkg ––configure –a

RUN apt-get install -y openjdk-11-jdk && \
    dotnet tool install --global dotnet-sonarscanner && \
    dotnet tool install --global coverlet.console

RUN dotnet sonarscanner begin /k:"dotnetapp" /d:sonar.host.url="http://192.168.0.43:9000"  /d:sonar.login="027d71bcea3948321b8ceaead882ac7d20806d5b"

# Copy everything else and build
COPY ./ /opt/blogifier

RUN dotnet build

RUN coverlet /opt/blogifier/tests/Blogifier.Tests/bin/Debug/net5.0/Blogifier.Tests.dll --target "dotnet" --targetargs "test --no-build" --format opencover

RUN dotnet sonarscanner end /d:sonar.login="027d71bcea3948321b8ceaead882ac7d20806d5b"

RUN ["dotnet","publish","./src/Blogifier/Blogifier.csproj","-o","./outputs" ]

FROM mcr.microsoft.com/dotnet/aspnet:5.0 as run
COPY --from=base /opt/blogifier/outputs /opt/blogifier/outputs
WORKDIR /opt/blogifier/outputs
ENTRYPOINT ["dotnet", "Blogifier.dll"]
EXPOSE 80
