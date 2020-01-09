using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Panino : MonoBehaviour
{
    private GameObject _player;

    //LerpVariables
    float _counter;
    public float _lerpMultiplier = 0.05f;

    Vector3 _finalScale;
    private void Start()
    {
        _player = GameObject.FindGameObjectWithTag("Player");
    }
    // Update is called once per frame
    void Update()
    {
        
    }


    private void OnTriggerStay(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            _counter += Time.deltaTime;

            transform.position = Vector3.Lerp(transform.position, _player.transform.GetChild(1).transform.position, _counter);
            if (transform.position == _player.transform.GetChild(1).transform.position)
            {
                GameManager._gm._follow = true;
                GameManager._gm._pickedUp = false;

                Destroy(gameObject);
            }
        }
    }
}
