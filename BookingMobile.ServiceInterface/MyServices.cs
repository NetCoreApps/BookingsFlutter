using ServiceStack;
using BookingMobile.ServiceModel;
using System;

namespace BookingMobile.ServiceInterface;

public class MyServices : Service
{
    public static string AssertName(string Name) => Name.IsNullOrEmpty() 
        ? throw new ArgumentNullException(nameof(Name))
        : Name;

    public object Any(Hello request) =>
        new HelloResponse { Result = $"Hello, {AssertName(request.Name)}!" };

    public object Any(HelloSecure request) => 
        new HelloResponse { Result = $"Hello, {AssertName(request.Name)}!" };
}
