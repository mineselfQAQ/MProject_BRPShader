using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveCamera : MonoBehaviour
{
    public Vector3 m_OriginPos;
    public float dist = 30.0f;
    void Awake()
    {
        Vector3 pos = this.transform.position;
        Vector3 originPos = m_OriginPos;
        if(pos != originPos) { pos = originPos; }
        this.transform.position = pos;
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Q))
        {
            this.transform.Translate(-dist, 0, 0);
        }
        if (Input.GetKeyDown(KeyCode.E))
        {
            this.transform.Translate(dist, 0, 0);
        }
    }

    public void MovePrevious()
    {
        this.transform.Translate(-dist, 0, 0);
    }
    public void MoveNext()
    {
        this.transform.Translate(dist, 0, 0);
    }
}
