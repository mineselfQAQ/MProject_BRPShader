using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Normalize : MonoBehaviour
{
    public Vector3 vec3;

    private void Awake()
    {
        vec3 = Vector3.Normalize(vec3);
        Debug.Log(vec3);
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
