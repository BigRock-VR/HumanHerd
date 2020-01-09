using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Human_ArmMovement : MonoBehaviour
{
    public Transform _armL, _armR;
    public float _walkTimer, _armsSpeed;

    //Lerp Variables
    private bool _counter;

    //Speed Variables
    Vector3 _lastPos;
    public float _moveSpeed;

    void Start()
    {
        GetObject();
        StartCoroutine(CalcVelocity());
    }

    void Update()
    {
        ArmMovement();
        //BodyMovement();
    }

    void GetObject()
    {
        _armL = gameObject.transform.GetChild(0).transform;
        _armR = gameObject.transform.GetChild(1).transform;
    }

    void ArmMovement()
    {
        if (GetComponent<SheepMovement>()._distance < GetComponent<SheepMovement>()._enemyCriticDistance)
        {
            if (_moveSpeed > 0)
            {
                _armsSpeed = _moveSpeed * 3f;
                LerpValue();
                _armL.localEulerAngles = new Vector3(_walkTimer + 180f, 0f, 0f);
                _armR.localEulerAngles = new Vector3(-_walkTimer + 180f, 0f, 0f);
            }
        }
        else
        {
            if (_moveSpeed > 0)
            {
                _armsSpeed = _moveSpeed;
                LerpValue();
                _armL.localEulerAngles = new Vector3(_walkTimer, 0f, 0f);
                _armR.localEulerAngles = new Vector3(-_walkTimer, 0f, 0f);
            }
            else
            {
                if (_walkTimer < 0f)
                {
                    _walkTimer += Time.deltaTime * _armsSpeed * 50f;
                    if (_walkTimer >= 0.2f)
                    {
                        _walkTimer = 0f;
                        _counter = false;
                    }
                }
                if (_walkTimer > 0f)
                {
                    _walkTimer -= Time.deltaTime * _armsSpeed * 50f;
                    if (_walkTimer <= 0.2f)
                    {
                        _walkTimer = 0f;
                        _counter = false;
                    }
                }
                _armL.localEulerAngles = new Vector3(_walkTimer, 0f, 0f);
                _armR.localEulerAngles = new Vector3(-_walkTimer, 0f, 0f);
            }
        }
    }


    private float LerpValue()
    {
        
        if(!_counter)
        {
            _walkTimer += Time.deltaTime * _armsSpeed * 50f;
            if (_walkTimer >= 45f)
            {
                _counter = true;
               
            }
        }
        if(_counter)
        {
            _walkTimer -= Time.deltaTime * _armsSpeed * 50f;
            if (_walkTimer <= -45f)
            {
                _counter = false;

            }
        }

        return  _walkTimer;
    }

    IEnumerator CalcVelocity()
    {
        while (Application.isPlaying)
        {
            _lastPos = transform.position;
            yield return new WaitForFixedUpdate();
            _moveSpeed = Mathf.RoundToInt(Vector3.Distance(transform.position, _lastPos) / Time.fixedDeltaTime);
        }
    }
}
