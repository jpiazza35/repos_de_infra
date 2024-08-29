/* eslint-disable no-undef */
/* eslint-disable cypress/unsafe-to-chain-command */
// ***********************************************
// This example commands.js shows you how to
// create various custom commands and overwrite
// existing commands.
//
// For more comprehensive examples of custom
// commands please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************
//
//
// -- This is a parent command --
// Cypress.Commands.add('login', (email, password) => { ... })
//
//
// -- This is a child command --
// Cypress.Commands.add('drag', { prevSubject: 'element'}, (subject, options) => { ... })
//
//
// -- This is a dual command --
// Cypress.Commands.add('dismiss', { prevSubject: 'optional'}, (subject, options) => { ... })
//
//
// -- This will overwrite an existing command --
// Cypress.Commands.overwrite('visit', (originalFn, url, options) => { ... })

// Cypress.Commands.add('selectNth',  { prevSubject: 'element' },
//   (subject, pos) => {
//     cy.wrap(subject)
//       .children('option')
//       .eq(pos)
//       .then(e => {
//         cy.wrap(subject).select(e.val(), {force : true})
//       })
//   }
// )

// Cypress.Commands.add('AutoCompleteFirstChild', (ctrl, text, selectText) => {
//   cy.get(ctrl).click({force : true}).clear({force : true}).type(text, {force : true});

//   cy.wait(2000).then((interception) => {
//     //cy.get('li.autocomplete-items', { timeout: 3000 }).should('be.visible', {force : true})
//     cy.contains('li.autocomplete-items', selectText).click( {force : true})
//     //cy.get('li.autocomplete-items(21st Century Oncology-1570)').first().click( {force : true})//;//.should('be.visible', {force : true})
//     //cy.get('li.autocomplete-items').first().click( {force : true});
//   })
// })

// Cypress.Commands.add('NavigateToMPTHomeAuthenticate', (userType) => {

//     cy.intercept({
//       method: 'GET',
//       url: Cypress.env("azureb2c_url") + '**'
//     }).as('auth')

//     // visit mpt url
//     //cy.visit('http://localhost:5173/')
//     cy.visit(Cypress.config('baseUrl') + "?domainhint=cliniciannexusb2cdev.onmicrosoft.com")

//     cy.get("body").then($body => {
//       if ($body.find("h3.app-title").length == 0) {
//         cy.wait('@auth').then(xhr => {
//           expect(xhr.request.url).to.contain(Cypress.env("azureb2c_url"))
//         })

//         cy.origin(Cypress.env("azureb2c_url"), { args : {userType}}, (ut) => {

//           if (ut.userType == 'admin')
//           {
//             cy.log(Cypress.env("azureb2c_admin_username"))
//             cy.get('#signInName').click().type(Cypress.env("azureb2c_admin_username"))
//             cy.get('#password').click().type(Cypress.env("azureb2c_admin_password"))
//           }
//           else if (ut.userType == 'client')
//           {
//             cy.get('#signInName').click().type(Cypress.env("azureb2c_client_username"))
//             cy.get('#password').click().type(Cypress.env("azureb2c_client_password"))
//           }

//           cy.get('button#next').click()
//         });
//       }
//     });
//   });
Cypress.Commands.add("oktaLogin", calltype => {
  Cypress.log({
    name: "loginViaAuth0",
  });

  const options = {
    method: "POST",
    url: "https://" + Cypress.env("auth0_domain") + "/oauth/token",
    body: {
      scope: "openid profile email offline_access",
      grant_type: "password",
      username: Cypress.env("auth0_admin_username"),
      password: Cypress.env("auth0_admin_password"),
      audience: Cypress.env("auth0_audience"),
      client_id: calltype == "ui" ? Cypress.env("auth0_ui_client_id") : Cypress.env("auth0_client_id"),
      client_secret: calltype == "ui" ? Cypress.env("auth0_ui_client_secret") : Cypress.env("auth0_client_secret"),
    },
  };

  cy.request(options);
});

Cypress.Commands.add("NavigateToMPTHomeAuthenticate", userType => {
  if (Cypress.env("cypress_auth_type") == "okta") {
    // cy.oktaLogin("ui").then(function (response) {
    //   const auth0State = {
    //     nonce: "",
    //     state: "some-random-state",
    //   };
    //   const callbackUrl = `/callback#access_token=${response.body.access_token}&scope=openid profile email&id_token=${response.body.id_token}&expires_in=${response.body.expires_in}&token_type=Bearer&state=${auth0State.state}`;
    //   cy.visit(callbackUrl, {
    //     onBeforeLoad(win) {
    //       win.document.cookie = "com.auth0.auth.some-random-state=" + JSON.stringify(auth0State);
    //     },
    //   });
    // });

    cy.clearLocalStorage();
    const client_id = Cypress.env("auth0_ui_client_id");
    const audience = Cypress.env("auth0_audience");
    const scope = "openid profile email offline_access";
    cy.oktaLogin("ui").then(({ body: { access_token, expires_in, id_token, token_type } }) => {
      cy.window().then(win => {
        // win.localStorage.setItem(
        //   `@@auth0spajs@@::${client_id}::${audience}::${scope}`,
        //   JSON.stringify({
        //     body: {
        //       client_id,
        //       access_token,
        //       id_token,
        //       scope,
        //       expires_in,
        //       token_type,
        //       decodedToken: {
        //         user: JSON.parse(Buffer.from(id_token.split(".")[1], "base64").toString("ascii")),
        //       },
        //       audience,
        //     },
        //     expiresAt: Math.floor(Date.now() / 1000) + expires_in,
        //   }));

        win.localStorage.setItem(
          `@@auth0spajs@@::${client_id}::${audience}::${scope}`,
          JSON.stringify({
            body: {
              access_token,
              scope,
              expires_in,
              token_type,
              audience,
              oauthTokenScope: "openid profile email",
              client_id,
            },
            expiresAt: Math.floor(Date.now() / 1000) + expires_in,
          }),
        );

        win.localStorage.setItem(
          `@@auth0spajs@@::${client_id}::@@user@@`,

          JSON.stringify({
            id_token,
            decodedToken: {
              user: JSON.parse(Buffer.from(id_token.split(".")[1], "base64").toString("ascii")),
            },
          }),
        );
      });
      cy.visit("/");
      //cy.reload();
    });
  } else {
    cy.intercept({
      method: "GET",
      url: Cypress.env("azureb2c_url") + "**",
    }).as("auth");

    // visit mpt url
    //cy.visit('http://localhost:5173/')
    cy.visit(Cypress.config("baseUrl") + "?domainhint=cliniciannexusb2cdev.onmicrosoft.com");

    cy.get("body").then($body => {
      cy.log("sidebarToggle length: " + $body.find('div[id="sidebarToggle"]').length);

      if ($body.find('div[id="sidebarToggle"]').length == 0) {
        cy.wait("@auth").then(xhr => {
          expect(xhr.request.url).to.contain(Cypress.env("azureb2c_url"));
        });

        cy.origin(Cypress.env("azureb2c_url"), { args: { userType } }, ut => {
          if (ut.userType == "admin") {
            cy.log(Cypress.env("azureb2c_admin_username"));
            cy.get("#signInName").click().type(Cypress.env("azureb2c_admin_username"));
            cy.get("#password").click().type(Cypress.env("azureb2c_admin_password"));
          } else if (ut.userType == "client") {
            cy.get("#signInName").click().type(Cypress.env("azureb2c_client_username"));
            cy.get("#password").click().type(Cypress.env("azureb2c_client_password"));
          }

          cy.get("button#next").click();
        });
      }
    });
  }
});

Cypress.Commands.add("logoutClientPortal", () => {
  if (Cypress.env("cypress_auth_type") == "okta") {
    cy.get("button[data-cy='dropdownLogout']").click({ force: true });
    cy.url().should("contain", Cypress.env("auth0_domain"));
  } else {
    cy.visit("/");
    cy.log("logoutClientPortal - 1");
    cy.get("a#dropdownUser").then($value => {
      if ($value.length > 0) {
        cy.get("#dropdownUser")
          .click()
          .then(function () {
            cy.get("button[data-cy=dropdownLogout]")
              .click()
              .then(function () {
                cy.log("logoutClientPortal - 2");
                cy.intercept({
                  method: "GET",
                  url: Cypress.env("azureb2c_url") + "**",
                }).as("auth");

                cy.log("logoutClientPortal - 3");

                cy.wait("@auth").then(xhr => {
                  cy.log("logoutClientPortal - 4");
                  expect(xhr.request.url).to.contain(Cypress.env("azureb2c_url"));
                });

                cy.log("logoutClientPortal - 5");
                cy.origin(Cypress.env("azureb2c_url"), () => {});
              });
          });
      }
    });
  }
});

Cypress.Commands.add("GenerateAPIToken", () => {
  if (Cypress.env("cypress_auth_type") == "okta") {
    //OKTA
    cy.oktaLogin("api").then(function (response) {
      cy.log(response.body.access_token);
      Cypress.env("token", response.body.access_token);
    });
  } else {
    //B2C
    cy.request({
      method: "POST",
      form: true,
      url: Cypress.env("azureb2c_url") + Cypress.env("azureb2c_api_url"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        scope: "openid " + Cypress.env("azureb2c_scope") + " offline_access",
        client_id: Cypress.env("azureb2c_client_id"),
        grant_type: "password",
        username: Cypress.env("azureb2c_admin_username"),
        password: Cypress.env("azureb2c_admin_password"),
        response_type: "token id_token",
      },
    }).then(function (response) {
      cy.log(response.body.access_token);
      //window.sessionStorage.setItem('authToken', )
      Cypress.env("token", response.body.access_token);
    });
  }
});

Cypress.Commands.add("SelectOrganization", (tab, orgName, projectId, projectVersion) => {
  tab.getOrganizationInput().click({ force: true }).clear({ force: true }).type(orgName, { force: true });
  cy.wait(2000);
  cy.get("select[data-cy=projectId]").selectNth(projectId);
  cy.get("select[data-cy=projectId]").trigger("change", {
    force: true,
  });
  cy.get("select[data-cy=projectVersion]").selectNth(projectVersion);
  cy.get("select[data-cy=projectVersion]").trigger("change", {
    force: true,
  });
});
