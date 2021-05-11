FROM mcr.microsoft.com/dotnet/core/sdk:3.1  as base


WORKDIR /opt/blogifier

RUN apk update  
RUN apk --no-cache add openjdk11 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community 
RUN dotnet tool install --global dotnet-ef 
RUN	dotnet tool install --global dotnet-sonarscanner 
RUN	dotnet tool install --global coverlet.console 
	
RUN dotnet sonarscanner begin /v:"1" /k:"jira_task" /d:sonar.host.url="http://127.0.0.1:9000" /d:sonar.login="bf893905ff3fa8c21981a604cee1c8ff9001995a"
	
# Copy everything else and build
COPY ./ /opt/blogifier

RUN dotnet build 

RUN ["dotnet","publish","./src/Blogifier/Blogifier.csproj","-o","./outputs" ]

RUN dotnet sonarscanner end d:sonar.login="bf893905ff3fa8c21981a604cee1c8ff9001995a"

FROM mcr.microsoft.com/dotnet/aspnet:5.0-alpine as run
COPY --from=base /opt/blogifier/outputs /opt/blogifier/outputs
WORKDIR /opt/blogifier/outputs
ENTRYPOINT ["dotnet", "Blogifier.dll"]
EXPOSE 80
