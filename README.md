# How to: get trees embeddings and process Deep Neural Networks Regressions on them

## Get trees embeddings:

### Laplacian Spectrum:

Use the Nextflow Pipeline (File: [Laplacian_Spectrum_Neural_Network/nextflow_construction.nf](https://github.com/tristandot/Prediction_epidemiological_parameters_by_neural_network/blob/master/Laplacian_Spectrum_Neural_Network/nextflow_construction.nf)) to filter the Newick forest and generate the Laplacian Spectrums for each tree. 
The code used to generate the Eigen Values of each tree is located in:  [Laplacian_Spectrum_Neural_Network/bin/spectreR.R](https://github.com/tristandot/Prediction_epidemiological_parameters_by_neural_network/blob/master/Laplacian_Spectrum_Neural_Network/bin/spectreR.R).

The final CSV files will be located in a current result/ directory.


### Other embeddings:

Other graphs embeddings can be used, as exposed in this article:
[Palash Goyal and Emilio Ferrara, 2017, Graph Embedding Techniques, Applications, and Performance: A Survey](https://arxiv.org/pdf/1705.02801.pdf).

Those embeddings (eventually processed), used as input data for our Neural Network, could give interesting training and prediction results, maybe better than the Laplacian Spectrums.

Thanks to the Python Library developed by the authors ([GEM Library](https://github.com/palash1992/GEM)), these embeddings can be easily implemented in the pipeline.
It is a work in progress, that can be found in the following Python Script: [Laplacian_Spectrum_Neural_Network/bin/generate_embeddings.py](https://github.com/tristandot/Prediction_epidemiological_parameters_by_neural_network/blob/master/Laplacian_Spectrum_Neural_Network/bin/generate_embeddings.py), and is in commentary in the current pipeline.


## Run the Neural Network:

### Installation of an Ubuntu Singularity Image on the Inception GPU Lab

In order to  easily run the Neural Network (coded in Keras with TensorFlow in backend) on the Inception GPU Lab, an Ubuntu (with Tensorflow and Pytorch) Singularity Image can be installed, as explained [here](https://gitlab.pasteur.fr/wouyang/singularity-tensorflow).

Then you can easily test the Network by, for example, using a Jupyter Notebook (to install and use Jupyter Notebooks on the GPU Lab, please follow [this](https://gitlab.pasteur.fr/inception-gpulab/wiki/blob/master/run_jupyter_notebook.md) explanation).

A ready-to-use Notebook is located here:
[Laplacian_Spectrum_Neural_Network/Network.ipynb](https://github.com/tristandot/Prediction_epidemiological_parameters_by_neural_network/blob/master/Laplacian_Spectrum_Neural_Network/Network.ipynb).

