using UnityEngine;

public class CameraDepthTextureMode : MonoBehaviour
{
    [SerializeField]
    private DepthTextureMode depthTextureMode;

    private void OnValidate()
    {
        SetCameraDepthTextureMode();
    }

    private void Awake()
    {
        SetCameraDepthTextureMode();
    }

    private void SetCameraDepthTextureMode()
    {
        Camera.main.depthTextureMode = depthTextureMode;
    }
}