using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;

public class PlayerController : MonoBehaviour
{

    [Header("GameControls Setups")]
    [SerializeField]
    [Range(1, 3)]
    int playMode = 3;

    [Space]

    [Header("General Movement Param")]
    public float _movSpeed = 8f;

    [SerializeField]
    float _rotSpeed = 150f;

    [SerializeField]
    float _runSpeedMultiplier = 0.4f;
    private float runSpeedMultiplier;

    [SerializeField]
    float _movSpeedMultiplier = 1;
    private float movSpeedMultiplier;

    [SerializeField]
    float _maxSpeed = 20;

    [Space]

    //Inputs Variables
    [SerializeField]
    KeyCode _pickUp;
    [SerializeField]
    KeyCode _drop;
    [SerializeField]
    KeyCode _sprint;

    private float _vMove, _hMove;

    private bool _sprintBool;
    private bool _inside;
    private bool _picked;
    private bool isRunning;

    private Rigidbody rb;
    private UIController uiController;

    //Panino
    private int _powerUpType;
    private float _paninoTimer;
    private GameObject[] _powerUps;
    [Header("Component of Type Power UP")]
    [SerializeField]
    GameObject _powerUpComponent;
    [Space]

    //Sprint
    [Header("Time before being fatigued")]
    [SerializeField]
    float _timeMultiplier;
    public float _counter;
    public bool _canRun = true;

    private float modifier;

    //AirBlobVariables
    private float _lerpFly;
    private bool _direction;
    private float _blobMultiplier = 0.4f;

    //RotationBySpeedVariables
    private float _lerpRot;

    //DeathVariables
    private float _lerpMultiplier = 0.05f;
    private float _lerpPos;
    private GameObject _spaceShip;

    void Start()
    {
        uiController = FindObjectOfType<UIController>();
        rb = transform.GetComponent<Rigidbody>();
        _powerUps = new GameObject[2];
        _spaceShip = GameObject.FindGameObjectWithTag("SpaceShip");
        PopulateArray();
    }

    void Update()
    {
        if (!GameManager._gm._gameOver)
        {
            MovementMain();
            Flying();
        }
        BoolSetting();
        PaninoPicked();
        GameOver();
    }

    void MovementMain()
    {
        _hMove = Input.GetAxis("Horizontal");
        _vMove = Input.GetAxis("Vertical");

        if (playMode == 1)
        {
            runSpeedMultiplier = _runSpeedMultiplier;
            movSpeedMultiplier = _movSpeedMultiplier;
            Move_1();
        }
        else if (playMode == 2)
        {
            Move_2();
        }
        else if (playMode == 3)
        {
            runSpeedMultiplier = (_runSpeedMultiplier / 2) * 10;
            movSpeedMultiplier = (_movSpeedMultiplier / 10) * 80;
            Move_3(false);
        }
        SprintCheck();
    }
    void SprintCheck()
    {
        if (_sprintBool && _canRun)
        {
            isRunning = true;

            _counter += Time.deltaTime * _timeMultiplier;
            _movSpeed += 0.08f;

            if (uiController._boostSpeedSlider.value >= uiController._boostSpeedSlider.maxValue)
            {
                rb.Sleep();
                _canRun = false;
            }

            if (rb.velocity.magnitude <= _maxSpeed)
            {
                if (playMode == 2)
                {
                    Move_3(true);
                }
                if (_counter >= 3f)
                {
                    rb.Sleep();
                    _canRun = false;
                }
            }
        }

        if (!_sprintBool || !_canRun)
        {
            isRunning = false;

            _counter -= Time.deltaTime * _timeMultiplier;
            _movSpeed -= 0.08f;

            if (_counter >= 0)
            {
                if (playMode == 2)
                {
                    Move_3(true);
                }
            }
            if (_counter <= 0f)
            {
                _movSpeed = 8f;
                _counter = 0f;
                _canRun = true;
            }
        }

        if (!isRunning)
        {
            modifier = movSpeedMultiplier;
        }
        else
        {
            modifier = runSpeedMultiplier;
        }
    }
    void Move_1()
    {
        //Aim var
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        Plane plane = new Plane(Vector3.up, Vector3.zero);
        float distance;

        //Move var
        float modifier;

        //Aim functions
        if (plane.Raycast(ray, out distance))
        {
            Vector3 target = ray.GetPoint(distance);
            Vector3 direction = target - transform.position;
            float rotation = Mathf.Atan2(direction.x, direction.z) * Mathf.Rad2Deg;
            transform.localRotation = Quaternion.Euler(0, rotation, 0);
        }

        //Move functions
        if (!isRunning)
        {
            modifier = movSpeedMultiplier;
        }
        else
        {
            modifier = runSpeedMultiplier;
        }

        if (_hMove != 0)
        {
            rb.AddForce(Vector3.right * _hMove * _movSpeed / modifier, ForceMode.Impulse);
        }
        if (_vMove != 0)
        {
            rb.AddForce(Vector3.forward * _vMove * _movSpeed / modifier, ForceMode.Impulse);
        }


    }
    void Move_2()
    {

    }
    void Move_3(bool rotate)
    {


        transform.Rotate(0f, _hMove * _rotSpeed * Time.deltaTime, 0f);
        transform.Translate(0f, 0f, _vMove * _movSpeed * modifier * movSpeedMultiplier * Time.deltaTime);

        if (rotate)
        {
            _lerpRot = _counter.Remap(0f, 3f, 0f, 1f);
            var x = Mathf.Lerp(0, 40, _lerpRot);
            transform.GetChild(0).transform.localRotation = Quaternion.Euler(x, transform.rotation.y, transform.rotation.z);
            rotate = false;
        }
    }
    void Flying()
    {
        if (!_direction)
        {
            _lerpFly += Time.deltaTime * _blobMultiplier;
            if (_lerpFly >= 1f)
            {
                _direction = true;
            }
        }
        if (_direction)
        {
            _lerpFly -= Time.deltaTime * _blobMultiplier;
            if (_lerpFly <= 0f)
            {
                _direction = false;
            }
        }
        var y = Mathf.Lerp(2f, 3f, _lerpFly);
        transform.position = Vector3.Lerp(transform.position, new Vector3(transform.position.x, y, transform.position.z), _lerpFly);
    }
    void PopulateArray()
    {
        for (int i = 0; i < _powerUps.Length; i++)
        {
            _powerUps[i] = _powerUpComponent.transform.GetChild(i).gameObject;
        }

    }
    void BoolSetting()
    {
        if (Input.GetKeyDown(_sprint))
        {
            _sprintBool = true;
        }
        if (Input.GetKeyUp(_sprint))
        {
            _sprintBool = false;
        }

    }
    void PaninoPicked()
    {
        if (GameManager._gm._follow && _powerUpType == 0)
        {
            _powerUps[0].SetActive(true);
            _paninoTimer += Time.deltaTime;

            if (_paninoTimer >= 10)
            {
                _powerUps[0].SetActive(false);
                _paninoTimer = 0f;
                GameManager._gm._follow = false;
            }
        }
        if (GameManager._gm._follow && _powerUpType == 1)
        {
            _powerUps[1].SetActive(true);
            _paninoTimer += Time.deltaTime;

            if (_paninoTimer >= 10)
            {
                _powerUps[1].SetActive(false);
                _paninoTimer = 0f;
                GameManager._gm._follow = false;
            }
        }
    }
    void GameOver()
    {
        if (GameManager._gm._timeOver && !_inside)
        {
            gameObject.transform.GetChild(2).gameObject.SetActive(false);
            GameManager._gm._gameOver = true;
        }
        if (GameManager._gm._timeOver && _inside)
        {
            _lerpPos += Time.deltaTime * _lerpMultiplier;
            transform.position = Vector3.Lerp(transform.position, new Vector3(_spaceShip.transform.position.x, _spaceShip.transform.position.y, _spaceShip.transform.position.z - 0.5f), _lerpPos);
            if (_lerpPos >= 0.3f)
            {
                gameObject.transform.GetChild(2).gameObject.SetActive(false);
                GameManager._gm._gameOver = true;
            }
        }
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Tornado"))
        {
            transform.SetParent(other.transform);
            GameManager._gm._gameOver = true;
        }
    }

    void OnTriggerStay(Collider other)
    {
        if (other.CompareTag("Panino"))
        {
            GameManager._gm._pickedUp = true;
            _powerUpType = 0;
        }
        if (other.CompareTag("Bibita"))
        {
            GameManager._gm._pickedUp = true;
            _powerUpType = 1;
        }

        if (other.CompareTag("Tornado"))
        {
            transform.SetParent(other.transform);

            _lerpPos += Time.deltaTime * _lerpMultiplier;
            transform.localPosition = Vector3.Lerp(transform.localPosition, new Vector3(0f, 0f, 0f), _lerpPos);
            if (_lerpPos >= 0.3f)
            {
                gameObject.transform.GetChild(2).gameObject.SetActive(false);
            }
        }

        if (other.CompareTag("SpaceShip"))
        {
            _inside = true;
        }
    }
    void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("SpaceShip"))
        {
            _inside = false;
        }
    }
}