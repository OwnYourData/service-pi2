# <img src="https://github.com/OwnYourData/service-pi2/raw/master/app/assets/images/oyd_blue.png" width="60"> PI2: Personally Identifiable Information Service    

The PI2 services acts as a local component in a control room to provide emergency information for a given DID. It resolves the DID to access a service endpoint and retrieves data. If this data is encrypted it uses Shamir's Secret Sharing scheme to decrypt data through multiple key parts. More informaton is available in this [blog post](https://www.ownyourdata.eu/en/managing-personal-data-in-emergency-calls/).



### OwnYourData Data Vault

The PI2 is a service for the OwnYourData Data Vault. Usually you have to pass on your data to the operators of web services and apps in order to be able to use them. OwnYourData, however, turns the tables: You keep all your data and you keep them in your own data vault. You bring apps (data collection, algorithms and visualization) and services to your data vault.

more information: https://www.ownyourdata.eu    
for developer: https://www.ownyourdata.eu/developer/    
Docker images: https://hub.docker.com/r/oydeu/app-consent    

&nbsp;    

## Deployment    

On using the PI2 service in a control room check the following items during deployment:    

* register the PI2 in the OwnYourData Data Vault to retrieve `Client-ID` and `Client-Secret` for authorizing the service (contact: support@ownyourdata.eu)
* provide credentials of the PI2 to the DEC112 Border service so that the Viewer can access the PI2   
    user the following command on the rails console:    

    ```
    > puts Doorkeeper::Application.first.uid
    > puts Doorkeeper::Application.first.secret
    ```

## Improve the PI2 Service

Please report bugs and suggestions for new features using the [GitHub Issue-Tracker](https://github.com/OwnYourData/service-pi2/issues) and follow the [Contributor Guidelines](https://github.com/twbs/ratchet/blob/master/CONTRIBUTING.md).

If you want to contribute, please follow these steps:

1. Fork it!
2. Create a feature branch: `git checkout -b my-new-feature`
3. Commit changes: `git commit -am 'Add some feature'`
4. Push into branch: `git push origin my-new-feature`
5. Send a Pull Request

&nbsp;    

## License

[MIT License 2020 - OwnYourData.eu](https://raw.githubusercontent.com/OwnYourData/service-pi2/master/LICENSE)