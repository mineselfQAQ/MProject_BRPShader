using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateLight : MonoBehaviour
{
    public float speed = 30;

    void Update()
    {
        transform.Rotate(0, Time.deltaTime * speed, 0, Space.World);
    }
}
