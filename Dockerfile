FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build

WORKDIR /src
COPY ["src/MerchService/MerchService.csproj","src/MerchService/"]
RUN dotnet restore "src/MerchService/MerchService.csproj"

COPY . .

WORKDIR "/src/src/MerchService"

RUN dotnet build "MerchService.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MerchService.csproj" -c Release -o /app/publish
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS runtime

WORKDIR /app

EXPOSE 80
EXPOSE 443

FROM runtime AS final
WORKDIR /app

COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet","MerchService.dll"]