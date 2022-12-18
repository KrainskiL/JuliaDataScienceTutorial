using Flux
using BSON: @load
using Genie, Genie.Requests, Genie.Renderer.Json

columns = ["crim","zn","indus","chas","nox","rm","age","dis","rad","tax","ptratio","black","lstat"]
@load "boston_nn.bson" model
@load "boston_nn_lin.bson" model_lin
@load "boston_nn_2hl.bson" model_2hl

ϵ = 0.8
global seed = 1
bandits = [("ReLU NN", model), 
            ("Linear NN", model_lin), 
            ("NN with Two Hidden Layers", model_2hl)]
pick_probs = ϵ:(1-ϵ)/(length(bandits)-1):1.0

route("/") do
"""<div style="white-space:pre">To receive a prediction send POST request with JSON payload.

Example:
>> curl -X POST -d @house.json -H "Content-Type: application/json" http://localhost:8000/
>> cat house.json
{
    "crim": 0.00632,
    "tax": 296.0,
    "chas": 0.0,
    "black": 396.9,
    "lstat": 4.98,
    "age": 65.2,
    "indus": 2.31,
    "rm": 6.575,
    "dis": 4.09,
    "zn": 18.0,
    "nox": 0.538,
    "ptratio": 15.3,
    "rad": 1.0
}</div>"""
end

route("/reset") do
    global seed = 1
    "Resetting the RNG seed."
end

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
            (bandit_name, bandit) = bandits[argmin(pick_probs .<= rand(Xoshiro(seed)))]
            global seed += 1
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