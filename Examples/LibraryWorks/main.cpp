#include <iostream>

#include <PxPhysicsAPI.h>

int main()
{
    physx::PxDefaultAllocator allocator{};
    physx::PxDefaultErrorCallback errorCallback{};

    const auto foundation = PxCreateFoundation(PX_PHYSICS_VERSION, allocator, errorCallback);
    const auto physics = PxCreatePhysics(PX_PHYSICS_VERSION, *foundation, physx::PxTolerancesScale(), true, nullptr);

    std::cout << "It works!" << std::endl;
    
    return 0;
}