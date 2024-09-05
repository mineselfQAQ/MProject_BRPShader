using UnityEngine;

public class VFX11_MoveCamera : MonoBehaviour
{
    public Camera camera;
    // Update is called once per frame
    void Update()
    {
        if (Input.GetAxis("Mouse ScrollWheel") < 0)
        {
            camera.orthographicSize += 0.5f;
        }
        if (Input.GetAxis("Mouse ScrollWheel") > 0)
        {
            camera.orthographicSize -= 0.5f;
        }
    }
}
