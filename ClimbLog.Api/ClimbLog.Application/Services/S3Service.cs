using Amazon.S3;
using Amazon.S3.Model;
using ClimbLog.Application.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;

namespace ClimbLog.Api.Services
{
    public class S3Service : IS3Service
    {
        private readonly AmazonS3Client client;

        public S3Service(IConfiguration configuraton)
        {
            client = new AmazonS3Client(configuraton["AWS:AccessKey"], configuraton["AWS:SecretKey"], Amazon.RegionEndpoint.APSoutheast2);
        }

        public async Task<string> UploadFileAsync(string fileName, IFormFile file)
        {
            string bucketName = "climblogapi";
            using (var stream = file.OpenReadStream())
            {
                var putRequest = new PutObjectRequest
                {
                    BucketName = bucketName,
                    Key = fileName,
                    InputStream = stream,
                    ContentType = file.ContentType, // Use the content type from IFormFile
                    AutoCloseStream = true
                };

                PutObjectResponse response = await client.PutObjectAsync(putRequest);
                
                string url = $"https://{bucketName}.s3.{client.Config.RegionEndpoint.SystemName}.amazonaws.com/{fileName}";

                return url;
            }
        }

        public async Task<bool> DeleteFileAsync(string fileName)
        {
            string bucketName = "climblogapi";

            var deleteRequest = new DeleteObjectRequest
            {
                BucketName = bucketName,
                Key = fileName
            };

            try
            {
                DeleteObjectResponse response = await client.DeleteObjectAsync(deleteRequest);
                return response.HttpStatusCode == System.Net.HttpStatusCode.NoContent;
            }
            catch (AmazonS3Exception ex)
            {
                // Optional: log the exception
                Console.WriteLine($"Error deleting object from S3: {ex.Message}");
                return false;
            }
        }
    }
}
