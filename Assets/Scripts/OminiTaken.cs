using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class OminiTaken : MonoBehaviour
{
    float _lerpPos1, _lerpPos2;
    float _lerpScale;
    public float _lerpMultiplier = 0.1f;

    private bool _stopLerp1;
    private int _stopLerp2;

    private GameObject _spaceShip;

    private void Start()
    {
        _spaceShip = GameObject.FindGameObjectWithTag("SpaceShip");
    }

    private void OnTriggerStay(Collider other)
    {
        if (other.CompareTag("SpaceShip"))
        {
            GetComponent<SheepMovement>().enabled = false;
            GetComponent<NavMeshAgent>().enabled = false;
            if (!_stopLerp1)
            {
                _lerpPos1 += Time.deltaTime * _lerpMultiplier;
            }
            var _newRot = Quaternion.Euler(-76, 180, 0);

            transform.rotation = Quaternion.Lerp(transform.rotation, _newRot, _lerpPos1);
            transform.position = Vector3.Lerp(transform.position, other.transform.GetChild(0).transform.position, _lerpPos1);
            if (_lerpPos1 >=0.04f)
            {
                _lerpScale += Time.deltaTime * _lerpMultiplier;
                _stopLerp1 = true;
                transform.localScale = Vector3.Lerp(transform.lossyScale, new Vector3(1f, 5.5f, 1f), _lerpScale);

                if (_lerpScale>=0.035f)
                {
                    _lerpScale -= Time.deltaTime * _lerpMultiplier;
                    _lerpPos2 += Time.deltaTime;

                    transform.position = Vector3.Lerp(transform.position, new Vector3(_spaceShip.transform.position.x, _spaceShip.transform.position.y, _spaceShip.transform.position.z - 0.5f), _lerpPos2);
                    transform.localScale = Vector3.Lerp(transform.lossyScale, new Vector3(1f, 0f, 1f), _lerpPos2);
                    if (_lerpPos2>=0.8f && _stopLerp2 == 0)
                    {

                        GameManager._gm.ScoreCounter();
                        GameManager._gm._humans.RemoveAt(0);
                        _stopLerp2++;
                        Destroy(gameObject);
                        
                    }
                }
                
            }
        }

        if (other.CompareTag("Tornado"))
        {
            transform.SetParent(other.transform);
            _lerpMultiplier = 0.01f;

            GetComponent<SheepMovement>().enabled = false;
            GetComponent<NavMeshAgent>().enabled = false;

            _lerpPos1 += Time.deltaTime * _lerpMultiplier;
            transform.localPosition = Vector3.Lerp(transform.localPosition, new Vector3(0f,0f,0f), _lerpPos1);
            if(_lerpPos1 >= 0.03)
            {
                Destroy(gameObject);
            }
        }
    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Tornado"))
        {
            transform.SetParent(other.transform);
            GetComponent<SheepMovement>().enabled = false;
            GetComponent<NavMeshAgent>().enabled = false;
            GameManager._gm._humans.RemoveAt(0);
        }
    }
}
