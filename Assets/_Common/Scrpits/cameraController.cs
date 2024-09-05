using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class cameraController : MonoBehaviour
{
    public GameObject target;

    public float verticalMax = 30;
    public float verticalMin = -30;

    public float disance = 5;
    public float speed = 3;

    private float verticalAngle;
    private float horizontalAngle;
    private Vector3 tem;

    // Update is called once per frame
    void Update()
    {
        CameraControl();
    }

    private void LateUpdate()
    {
        Quaternion quaternion = Quaternion.Euler(verticalAngle, horizontalAngle, 0);

        tem = new Vector3(0, 0, -disance);

        Vector3 position = quaternion * tem + target.transform.position;

        transform.rotation = quaternion;
        transform.position = position;
    }

    public void CameraControl()
    {
        if (Input.GetMouseButton(0))
        {
            verticalAngle -= Input.GetAxis("Mouse Y") * speed;
            horizontalAngle += Input.GetAxis("Mouse X") * speed;

            verticalAngle = AngleClamp(verticalAngle, verticalMin, verticalMax);
        }
    }

    static float AngleClamp(float angle, float min, float max)
    {
        if (angle < -360)
            angle += 360;
        if (angle > 360)
            angle -= 360;

        return Mathf.Clamp(angle, min, max);
    }
}
