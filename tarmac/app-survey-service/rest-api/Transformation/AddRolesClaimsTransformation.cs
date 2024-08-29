using Cn.User;
using Microsoft.AspNetCore.Authentication;
using System.Security.Claims;

namespace CN.Survey.RestApi.Transformation;

public class AddRolesClaimsTransformation : IClaimsTransformation
{
    private readonly User.UserClient _userClient;

    public AddRolesClaimsTransformation(User.UserClient userClient)
    {
        _userClient = userClient;
    }

    public async Task<ClaimsPrincipal> TransformAsync(ClaimsPrincipal principal)
    {
        // Clone current identity
        var clone = principal.Clone();
        try
        {
            var newIdentity = clone.Identity as ClaimsIdentity;

            if (newIdentity != null)
            {
                // Support AD and local accounts
                var nameId = principal.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier || c.Type == ClaimTypes.Name);

                if (nameId == null)
                    return principal;

                var email = principal.Claims.FirstOrDefault(c => c.Type == ClaimTypes.Email);

                // Get user from database
                var request = new UserRolesRequest { UserObjectId = nameId.Value, UserEmail = email?.Value };
                var response = await _userClient.ListRolesByUserObjectIDAsync(request);

                if (response == null || !response.Roles.Any())
                    return principal;

                // Add role claims to cloned identity
                foreach (var role in response.Roles)
                {
                    var claim = new Claim(newIdentity.RoleClaimType, role);

                    newIdentity.AddClaim(claim);
                }
            }

            return clone;
        }
        catch
        {
            return clone;
        }
    }
}