#Epsilon greedy 3-armed bandit
using Pkg
Pkg.activate(".")
Pkg.instantiate()
using Flux
using BSON: @load
using Genie, Genie.Requests, Genie.Renderer.Json

columns = ["crim","zn","indus","chas","nox","rm","age","dis","rad","tax","ptratio","black","lstat"]
@load "boston_nn.bson" model
@load "boston_nn_lin.bson" model_lin
@load "boston_nn_2hl.bson" model_2hl

ϵ = 0.5
bandits = [("ReLU Neural Network",model), 
            ("Linear Neural Network",model_lin), 
            ("Neural Network with Two Hidden Layers",model_2hl)]
pick_probs = ϵ:ϵ/(length(bandits)-1):1.0

route("/", method = POST) do
    input_data = jsonpayload()
    keys_json = keys(input_data)
    missing_fields = [k for k in columns if k ∉ keys_json]
    
    if length(missing_fields) != 0
        missing_str = join(missing_fields, ",")
        Json.json(:error => "The fields: $missing_str are missing from the JSON payload."*
            "The prediction can not be returned.")
    else     
        try
            (bandit_name, bandit) = bandits[argmin(pick_probs .<= rand())]
            print(bandit_name)
            Json.json(Dict("input" => input_data,
                        "prediction" => bandit([input_data[f] for f in columns])[1],
                        "model" => bandit_name)
                     )
        catch e
            Json.json(:error => "Ooops! There was a problem while generating a prediction.")
        end
    end
end
up(port=8000, async=false)