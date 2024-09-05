using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EarthRotate : MonoBehaviour
{
    public float speed;
    // Update is called once per frame
    void Update()
    {
        //transform.Rotate(new Vector3(0, 0, speed));

        transform.localRotation = Quaternion.Euler(0, speed, 0) * transform.localRotation;
    }
}
