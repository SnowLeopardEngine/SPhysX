#include <iostream>

#include <PxPhysicsAPI.h>

using namespace physx;

int main()
{
    PxDefaultAllocator allocator{};
    PxDefaultErrorCallback errorCallback{};

    // create foundation
    const auto foundation = PxCreateFoundation(PX_PHYSICS_VERSION, allocator, errorCallback);
    if (!foundation)
    {
        std::cerr << "PxCreateFoundation failed!" << std::endl;
    }

    // create pvd (debugging handle)
    const auto pvd = PxCreatePvd(*foundation);

    // create pvd session, connect.
    const auto transport = PxDefaultPvdSocketTransportCreate("127.0.0.1", 5425, 100);
    pvd->connect(*transport, PxPvdInstrumentationFlag::eALL);

    // create physics
    const auto physics = PxCreatePhysics(PX_PHYSICS_VERSION, *foundation, PxTolerancesScale(), true, pvd);
    if (!physics)
    {
        std::cerr << "PxCreatePhysics failed!" << std::endl;
    }

    // create a scene
    PxSceneDesc sceneDesc(physics->getTolerancesScale());
    auto scene = physics->createScene(sceneDesc);
    scene->setGravity(PxVec3(0.0f, -9.8f, 0.0f)); // global gravity

    // create a plane
    PxTransform groundTransform(PxVec3(0.0f, -2.0f, 0.0f));
    auto groundPlane = PxCreatePlane(*physics, PxPlane(0, 1, 0, 0), *physics->createMaterial(0.5f, 0.5f, 0.5f));
    scene->addActor(*groundPlane);

    // create a sphere shape and rigid dynamics
    PxTransform transform(PxVec3(0.0f, 10.0f, 0.0f));
    PxSphereGeometry sphereGeometry(1.0f);
    auto ball = PxCreateDynamic(*physics, transform, sphereGeometry, *physics->createMaterial(0.5f, 0.5f, 0.5f), 1.0f);
    scene->addActor(*ball);

    // simulate physics world
    for (int i = 0; i < 100; ++i)
    {
        scene->simulate(1.0f / 60.0f);
        scene->fetchResults(true);

        // print ball position info
        auto ballTransform = ball->getGlobalPose();
        auto ballPosition = ballTransform.p;
        std::cout << "Step " << i << ": Ball Position - X: " << ballPosition.x << " Y: " << ballPosition.y << " Z: " << ballPosition.z << std::endl;
    }

    std::cout << "Simulation End!" << std::endl;

    physics->release();
    foundation->release();

    return 0;
}