// David Eberly, Geometric Tools, Redmond WA 98052
// Copyright (c) 1998-2021
// Distributed under the Boost Software License, Version 1.0.
// https://www.boost.org/LICENSE_1_0.txt
// https://www.geometrictools.com/License/Boost/LICENSE_1_0.txt
// Version: 4.0.2019.08.13

#pragma once

#include <Applications/Window3.h>
#include "RandomController.h"
using namespace gte;

class PointControllersWindow3 : public Window3
{
public:
    PointControllersWindow3(Parameters& parameters);

    virtual void OnIdle() override;

private:
    void CreateScene();

    struct Vertex
    {
        Vector3<float> position;
        Vector4<float> color;
    };

    std::shared_ptr<Visual> mPoints;
    std::shared_ptr<RandomController> mRandomController;
    double mApplicationTime, mApplicationDeltaTime;
};
