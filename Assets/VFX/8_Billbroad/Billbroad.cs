using UnityEngine;

public class Billbroad : MonoBehaviour
{
    // Update is called once per frame
    void Update()
    {
        Transform dir = Camera.main.transform;
        transform.LookAt(dir);

        Quaternion inv = Quaternion.Euler(0, 180, 0);
        transform.rotation = transform.rotation * inv;
    }
}
