import math
import metapy
import sys
import time

def make_classifier(training, inv_idx, fwd_idx):
    """
    Use this function to train and return a Classifier object of your
    choice from the given training set. (You can ignore the inv_idx and
    fwd_idx parameters in almost all cases, but they are there if you need
    them.)

    **Make sure you update your config.toml to change your feature
    representation!** The data provided here will be generated according to
    your specified analyzer pipeline in your configuration file (which, by
    default, is going to be unigram words).

    Also, if you change your feature set and already have an existing
    index, **please make sure to delete it before running this script** to
    ensure your new features are properly indexed.
    """
    "return metapy.classify.OneVsAll(training, metapy.classify.SGD, loss_id='hinge')"
    return metapy.classify.NaiveBayes(training)

def transform_dataset(dataset, inv_idx, fwd_idx):
    """
    Use this function to modify the dataset provided (e.g., to add new
    features or to modify existing feature weights). Using one of the
    built-in transformations does not require constructing a new dataset
    object, but adding features does (because the total feature count
    changes).

    `inv_idx` is an InvertedIndex over the supplied dataset
    `fwd_idx` is a ForwardIndex over the supplied dataset

    If you add additional features, I recommend using the 4 argument
    constructor to make your new MulticlassDataset:

        instances = [inst for inst in dataset]
        new_dset = metapy.learn.MulticlassDataset(instances,
                                                  total_feature_count,
                                                  featurizer,
                                                  labeler)

    where `total_feature_count` should be `dataset.total_features()` plus
    the number of new feature _types_ you plan to add to the dataset.

    `featurizer` is a function that takes a metapy.learn.Instance and
    returns a metapy.learn.FeatureVector with whatever features you'd like.
    Here's a starting point:

        def featurizer(inst):
            start_id = dataset.total_features()

            fvec = metapy.learn.FeatureVector(inst.weights)

            # modify fvec to add new features
            fvec[start_id + (offset)] = value
            fvec[start_id + (larger_offset)] = value
            # etc...

            return fvec

    `labeler` is a function that takes a metapy.learn.Instance and
    returns its label; you will probably just use the following:

        def labeler(inst):
            return dataset.label(inst)


    Return the new, modified dataset to be used for training/testing
    """
    
    def featurizer(inst):
        global i
        start_id = dataset.total_features()
        n1 = float
        n2 = int
        n3 = int
        fvec = metapy.learn.FeatureVector(inst.weights)
        f = open('hygiene/hygiene.dat.additional','r')
        line = f.readlines()
        n1 = float(line[inst.id].strip().split(',')[len(line[inst.id].strip().split(','))-1])
        n2 = int(line[inst.id].strip().split(',')[len(line[inst.id].strip().split(','))-2])
        f.close()
        n1 = round(n1,1)
        "# modify fvec to add new features"
        fvec[start_id + 1] = n1
        fvec[start_id + 2] = n2
        "fvec[start_id + (larger_offset)] = value"
        "# etc..."
        return fvec

    def labeler(inst):
        return dataset.label(inst)
    
    total_feature_count = dataset.total_features()+2
    instances = [inst for inst in dataset]
    new_dset = metapy.classify.MulticlassDataset(instances,
                                    total_feature_count,
                                    featurizer,
                                    labeler)

    return new_dset # change me, if you want

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print("Usage: {} config.toml".format(sys.argv[0]))
        sys.exit(1)

    
    metapy.log_to_stderr()

    i = 0
    cfg = sys.argv[1]
    print('Building or loading indexes...')
    inv_idx = metapy.index.make_inverted_index(cfg)
    fwd_idx = metapy.index.make_forward_index(cfg)

    dset = metapy.classify.MulticlassDataset(fwd_idx)
    dset = transform_dataset(dset, inv_idx, fwd_idx)

    view = dset[0:len(dset)+1]
    train_view = view[0:7000]
    test_view = view[7000:len(view)+1]
    
    print('Running cross-validation...')
    start_time = time.time()
    matrix = metapy.classify.cross_validate(lambda fold:
            make_classifier(fold, inv_idx, fwd_idx), train_view, 5)

    print(matrix)
    matrix.print_stats()
    print("Elapsed: {} seconds".format(round(time.time() - start_time, 4)))
