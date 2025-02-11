FROM mcr.microsoft.com/dotnet/core/sdk:3.1  as base

WORKDIR /opt/blogifier
ENV PATH="$PATH:/root/.dotnet/tools"

RUN wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
	
RUN apt-get update; \
    apt-get install -y apt-transport-https && \
    apt-get update && \
    apt-get install -y aspnetcore-runtime-5.0

RUN apt-get update; \
    apt-get install -y apt-transport-https && \
    apt-get update && \
    apt-get install -y dotnet-sdk-5.0

RUN apt-get update && apt-get install -y openjdk-11-jdk && \
    dotnet tool install --global dotnet-sonarscanner && \
    dotnet tool install --global coverlet.console 
	
RUN dotnet sonarscanner begin /v:"1" /k:"jira_task" /d:sonar.host.url="http://127.0.0.1:9000" /d:sonar.login="bf893905ff3fa8c21981a604cee1c8ff9001995a" /d:sonar.cs.opencover.reportsPaths=coverage.opencover.xml
	
# Copy everything else and build
COPY ./ /opt/blogifier
RUN dotnet restore -v m 

RUN dotnet build --no-restore --nologo


RUN ["dotnet","publish","./src/Blogifier/Blogifier.csproj","-o","./outputs" ]

RUN coverlet /opt/blogifier/tests/Blogifier.Tests/bin/Debug/net5.0/Blogifier.Tests.dll --target "dotnet" --targetargs "test --no-build" --format opencover

RUN dotnet sonarscanner end /d:sonar.login="bf893905ff3fa8c21981a604cee1c8ff9001995a"

FROM mcr.microsoft.com/dotnet/aspnet:5.0 as run
COPY --from=base /opt/blogifier/outputs /opt/blogifier/outputs
WORKDIR /opt/blogifier/outputs
ENTRYPOINT ["dotnet", "Blogifier.dll"]
EXPOSE 80
