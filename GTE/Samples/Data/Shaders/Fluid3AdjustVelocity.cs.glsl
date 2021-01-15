// David Eberly, Geometric Tools, Redmond WA 98052
// Copyright (c) 1998-2021
// Distributed under the Boost Software License, Version 1.0.
// https://www.boost.org/LICENSE_1_0.txt
// https://www.geometrictools.com/License/Boost/LICENSE_1_0.txt
// Version: 4.0.2019.08.13

uniform Parameters
{
    vec4 spaceDelta;    // (dx, dy, dz, 0)
    vec4 halfDivDelta;  // (0.5/dx, 0.5/dy, 0.5/dz, 0)
    vec4 timeDelta;     // (dt/dx, dt/dy, dt/dz, dt)
    vec4 viscosityX;    // (velVX, velVX, velVX, denVX)
    vec4 viscosityY;    // (velVX, velVY, velVY, denVY)
    vec4 viscosityZ;    // (velVZ, velVZ, velVZ, denVZ)
    vec4 epsilon;       // (epsilonX, epsilonY, epsilonZ, epsilon0)
};

layout(rgba32f) uniform readonly image3D inState;
layout(r32f) uniform readonly image3D poisson;
layout(rgba32f) uniform writeonly image3D outState;

layout (local_size_x = NUM_X_THREADS, local_size_y = NUM_Y_THREADS, local_size_z = NUM_Z_THREADS) in;
void main()
{
    ivec3 c = ivec3(gl_GlobalInvocationID.xyz);
    ivec3 dim = imageSize(inState);

    int x = int(c.x);
    int y = int(c.y);
    int z = int(c.z);
    int xm = max(x - 1, 0);
    int xp = min(x + 1, dim.x - 1);
    int ym = max(y - 1, 0);
    int yp = min(y + 1, dim.y - 1);
    int zm = max(z - 1, 0);
    int zp = min(z + 1, dim.z - 1);

    // Sample the state at (x,y,z).
    vec4 state = imageLoad(inState, c);

    // Sample Poisson values at immediate neighbors of (x,y,z).
    float poisPZZ = imageLoad(poisson, ivec3(xp, y, z)).x;
    float poisMZZ = imageLoad(poisson, ivec3(xm, y, z)).x;
    float poisZPZ = imageLoad(poisson, ivec3(x, yp, z)).x;
    float poisZMZ = imageLoad(poisson, ivec3(x, ym, z)).x;
    float poisZZP = imageLoad(poisson, ivec3(x, y, zp)).x;
    float poisZZM = imageLoad(poisson, ivec3(x, y, zm)).x;

    vec4 diff = vec4(poisPZZ - poisMZZ, poisZPZ - poisZMZ, poisZZP - poisZZM, 0.0f);
    imageStore(outState, c, state + halfDivDelta * diff);
}
