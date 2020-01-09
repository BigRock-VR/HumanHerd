using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TornadoScript : MonoBehaviour
{
    Rigidbody tornado;
    public float rotSpeed;

    // Start is called before the first frame update
    void Start()
    {
        tornado = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        tornado.AddTorque(Vector3.up * rotSpeed);
    }
}
