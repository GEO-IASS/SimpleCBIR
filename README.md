# SimpleCBIR

## Execution

Before running this program, you need to prepare some images as the dataset and save it in the `dataset/[category]/` directory. `[category]` is the name of category the image belongs to.

Then, just executes:

    $ cd src/
    $ octave main.m
    
The program will perform leave-one-out cross validation on different distance metrics for each image categories, and save the precision-recall curves (PR curves) on the `figure` directory (with the name `[category]_[metric].png`).

## Distance Metrics

There are 4 distance metrics for calculating the (dis)similarity between images.

### Color Distance

**Grid Color Moments (GCM)** are chose as the color feature.

Each image is divided into 5 × 5 grids. For each grid, I calculate its 1st, 2nd, and 3rd moments (that is, mean, standard deviation, and skewness) of each color channel. Then, the feature extracted from each grid are combined as a long feature to capture the spatial information. In total, there are 25 grids × 3 color channels × 3 moments = 225 dimensions.

I use HSV color space, rather than RGB color space. That is because, RGB color space is NOT perception-uniform: equal distances in different areas and along different dimensions of the RGB space do not correspond to equal perception of color dissimilarity.

After generating feature for each image, I use L2 distance to calculate the dissimilarity for each pair of images.

See [`gcm()`](https://github.com/jason2506/SimpleCBIR/blob/master/src/gcm.m).

### Edge Distance

**Pyramid of Histograms of Orientation Gradients (PHOG)** are used as the edge feature.

Each image is divided into a sequence of increasingly finer spatial grids by repeatedly doubling the number of divisions in each axis direction (like a quadtree). Then, the histogram of orientation gradient (HOG) vector is computed for each grid at each pyramid level. The final feature for the image is a concatenation of all the HOG vectors.

The implementation details follow the proposed paper: edges are extracted using the Canny edge detector on grayscale images, the orientation gradients are computed using a 3 × 3 Sobel mask. L2 distance is also used as the distance metric, because the paper has proved that it is outperforms histogram intersection and cosine similarity for this feature.

See [`sobel()`](https://github.com/jason2506/SimpleCBIR/blob/master/src/sobel.m) and [`phog()`](https://github.com/jason2506/SimpleCBIR/blob/master/src/phog.m).

#### References:

* Anna Bosch, Andrew Zisserman, and Xavier Munoz. **Representing shape with a spatial pyramid kernel**. In *Proceedings of the 6th ACM international conference on Image and video retrieval* (CIVR'07), pages 401–408, New York, NY, USA, 2007. ACM.

### Fusion (for Color and Edge)

After calculating the color distance and edge distance, **Borda count** is used to aggregate these two metrics. The main idea is that it ignores the absolute scores and preserves only the preferences (ranks) of list.

Suppose that we want to find images similar to some given one. For each image, I just sum up the position of preference lists which are ranked by the color distance and edge distance to the given image, respectively. The resulting scores can then be used as the dissimilarity metric.

See [`borda()`](https://github.com/jason2506/SimpleCBIR/blob/master/src/borda.m).

### Hamming Distance (by Random Projection on Edge Feature)

After extracting the edge feature, this feature is also used to generate *k*-bit binary codes by performing **random projection**.

Each binary code is defined as

![h(x) = (\text{sign}(w^{T}x)+1)/2](http://chart.apis.google.com/chart?cht=tx&chl=h\(x\)%3D(%5Ctext%7Bsign%7D\(w%5E%7BT%7Dx\)%2B1\)%2F2)

where *x* is (*d*-dimensional) edge feature, *w* is *d*-dimensional and randomly sampled from Gaussian distribution with mean = 0 and standard deviation = 1.

Then, the **hamming distance** on the generated binary codes is the last distance metric used in this system.

The program will evaluate the performance by using *k* = *d*, *d* / 2, *d* / 3 and plot the three curves on the same figure for comparison.

See [`randproj()`](https://github.com/jason2506/SimpleCBIR/blob/master/src/randproj.m).
