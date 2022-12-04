# Course on Data Science and Machine Learning in Julia

The repository consists of eight classes covering the successive steps of Data Science and ML process. Each class includes a Jupyter notebook with the core material and additional artifacts (flat files, Julia scripts, images, etc.). The notebooks creates a logically progressing series, but may be run independently as well.

The topics covered are as follows:
1. Data Retrieval and Manipulation
2. Data Cleaning and Preprocessing
3. Exploratory Data Analysis
4. Building and Assessing ML Models
5. Model Tuning
6. Explaining The Models - Interpretable AI
7. AutoML
8. Model Deployment and Monitoring

If you'd like to test your Julia and Data Science skills in practice, you may be interested in the [Hands-On Data Science with Julia](https://www.manning.com/liveprojectseries/data-science-with-julia-ser) - a collection of projects focused on solving business problems with Julia, data analysis and modelling.

## Usage instructions

Make sure you have the [Julia](https://julialang.org/downloads/) installed.
The course was prepared under Julia 1.8.2.

1. Clone the repository to a local folder on your computer:
```shell
git clone https://github.com/KrainskiL/JuliaDataScienceTutorial
```
2. Start Julia in your local folder:
```shell
cd JuliaDataScienceTutorial
julia --project
```
3. Run the following commands in the Julia REPL:
```julia
using Pkg
Pkg.instantiate()
Pkg.status()
```
4. Start Jupyter Notebook with:
```julia
using IJulia
notebook(dir=pwd())
```

---

*Preparation of the educational materials has been supported by the Polish National Agency for Academic Exchange under the Strategic Partnerships programme, grant number BPI/PST/2021/1/00069/U/00001.*

![SGH & NAWA](logo.png)