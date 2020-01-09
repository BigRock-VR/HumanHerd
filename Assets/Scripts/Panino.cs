using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Panino : MonoBehaviour
{
    private GameObject _player;

    //LerpVariables
    float _counter;
    float _distance;
    public float _lerpMultiplier = 0.05f;

    private void OnTriggerStay(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            _player = other.gameObject;
            _distance = Vector3.Distance(transform.position, _player.transform.position);
            print("Distanza = " + _distance);
            _counter += Time.deltaTime;

            transform.position = Vector3.Lerp(transform.position, _player.transform.GetChild(1).transform.position, _counter);
            if (_distance <= 0.9f) 
            {
                GameManager._gm._follow = true;
                GameManager._gm._pickedUp = false;

                Destroy(gameObject);
            }
        }
    }
}
