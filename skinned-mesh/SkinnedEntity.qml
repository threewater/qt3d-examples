import Qt3D.Core 2.10
import Qt3D.Render 2.10
import Qt3D.Input 2.0
import Qt3D.Extras 2.10

Entity {
    id: root

    property Effect effect: texturedSkinnedPbrEffect
    property url source: ""
    property alias createJointsEnabled: skeleton.createJointsEnabled
    property alias transform: transform

    // TODO: Redo in C++ with logic to switch between texture or constant solid color
    // and enable/disable shader graph layers accordingly
    property alias baseColor: material.baseColor
    property alias metalness: material.metalness
    property alias roughness: material.roughness
    property alias normal: material.normal
    property alias ambientOcclusion: material.ambientOcclusion

    property alias rootJoint: skeleton.rootJoint
    property alias skeleton: skeleton

    components: [
        Transform {
            id: transform
        },
        Mesh {
            source: root.source
        },
        Armature {
            skeleton: SkeletonLoader {
                id: skeleton
                source: root.source
                onStatusChanged: console.log("skeleton loader status: " + status)
                onJointCountChanged: console.log("skeleton has " + jointCount + " joints")
            }
        },
        Material {
            id: material

            property var baseColor: "red"
            onBaseColorChanged: console.log(baseColor)
            property var metalness: 0.1
            property var roughness: 0.2
            property var normal: Qt.rgba(0.5, 0.5, 1.0, 1.0); // Neutral normal map color
            property var ambientOcclusion: "white"

            effect: root.effect

            parameters: [
                Parameter { name: effect.useTextures ? "baseColorMap" : "baseColor"; value: material.baseColor },
                Parameter { name: effect.useTextures ? "metalnessMap" : "metalness"; value: material.metalness },
                Parameter { name: effect.useTextures ? "roughnessMap": "roughness"; value: material.roughness },
                Parameter { name: effect.useTextures ? "normalMap" : "normal"; value: material.normal },
                Parameter { name: effect.useTextures ? "ambientOcclusionMap" : "ambientOcclusion"; value: material.ambientOcclusion }
            ]
        }
    ]
}
