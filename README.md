SyntheticCameraProjection
=========================

Synthetic Point3D to Point2D for test

execute: RunSyntheticTest.m

goal: simulate camera projection process to generate synthetic point correspondences

RunSyntheticTest
    RunSyntheticProj #NOTE variable name pt[23]d[ LR] should match
        RotMat()
    FMat8pt()
        normalise2dpts()
    ShowView()
    ShowWorld()

TODO:
    output image file for rectification
    RANSAC
    synthetic distortion model
